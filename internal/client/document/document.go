package document

import (
	"context"
	"fmt"
	"io"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/s3"
	"gitlab.com/eqshare/eqshare-back/config"
	"gitlab.com/eqshare/eqshare-back/model"
)

type Remote struct {
	s3  *s3.S3
	cfg *config.ObjectStorage
}

func NewRemote(s3 *s3.S3, cfg *config.ObjectStorage) *Remote {
	return &Remote{
		s3:  s3,
		cfg: cfg,
	}
}

func key(doc model.Document) string {
	return fmt.Sprintf("%s/%s%s", doc.CreatedAt.Format("2006-01-02"), doc.Path.String(), doc.Extension)
}

func (r *Remote) Upload(ctx context.Context, doc model.Document) (model.Document, error) {
	object := s3.PutObjectInput{
		Bucket:      aws.String(r.cfg.Bucket),
		Key:         aws.String(key(doc)),
		Body:        doc.RequestContent,
		ContentType: aws.String(doc.Type),
		ACL:         aws.String("private"),
		Metadata: map[string]*string{
			"x-amz-meta-my-key": aws.String(doc.Path.String()),
		},
	}

	_, err := r.s3.PutObjectWithContext(ctx, &object)
	if err != nil {
		return doc, err
	}

	_, err = r.UploadThumbnail(ctx, doc)
	if err != nil {
		return doc, err
	}

	return doc, nil
}

func (r *Remote) Get(ctx context.Context, doc model.Document) (model.Document, error) {
	object := s3.GetObjectInput{
		Bucket: aws.String(r.cfg.Bucket),
		Key:    aws.String(key(doc)),
	}

	out, err := r.s3.GetObjectWithContext(ctx, &object)
	if err != nil {
		return doc, err
	}

	doc.ResponseContent, err = io.ReadAll(out.Body)
	if err != nil {
		return doc, err
	}

	return doc, nil
}

func (r *Remote) Delete(ctx context.Context, doc model.Document) (model.Document, error) {
	object := s3.DeleteObjectInput{
		Bucket: aws.String(r.cfg.Bucket),
		Key:    aws.String(key(doc)),
	}

	// logrus.Debugf("[object input]: %+v", object)
	_, err := r.s3.DeleteObjectWithContext(ctx, &object)
	if err != nil {
		return doc, err
	}
	// logrus.Debugf("[object output]: %+v", out)

	if err = r.s3.WaitUntilObjectNotExistsWithContext(ctx, &s3.HeadObjectInput{
		Bucket: aws.String(r.cfg.Bucket),
		Key:    aws.String(key(doc)),
	}); err != nil {
		return doc, err
	}

	return doc, nil
}

func (r *Remote) Share(ctx context.Context, doc model.Document, duration time.Duration) (model.Document, error) {
	object := s3.GetObjectInput{
		Bucket: aws.String(r.cfg.Bucket),
		Key:    aws.String(key(doc)),
	}

	req, _ := r.s3.GetObjectRequest(&object)

	link, err := req.Presign(duration)
	if err != nil {
		return doc, err
	}

	thumbnailLink, err := r.GenerateThumbnail(doc, duration)
	if err != nil {
		return doc, err
	}

	doc.ShareLink = link
	doc.ThumbnailLink = thumbnailLink
	return doc, nil
}
