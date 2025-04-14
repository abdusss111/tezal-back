package document

import (
	"bytes"
	"context"
	"fmt"
	"github.com/sirupsen/logrus"
	"image"
	"image/jpeg"
	"image/png"

	"io"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/chai2010/webp"
	"github.com/nfnt/resize"

	"gitlab.com/eqshare/eqshare-back/model"
)

func thumbnailKey(doc model.Document) string {
	return fmt.Sprintf("%s/%s-thumbnail%s", doc.CreatedAt.Format("2006-01-02"), doc.Path.String(), doc.Extension)
}

func compressImage(input io.ReadSeeker, format string) (io.ReadSeeker, error) {
	var img image.Image
	var err error
	switch format {
	case ".webp":
		img, err = webp.Decode(input)
	case ".jpeg", ".jpg":
		img, _, err = image.Decode(input)
	case ".png":
		img, err = png.Decode(input)

	default:
		return nil, nil
	}

	if err != nil {
		return nil, err
	}

	//if format == ".webp" {
	//	img, err = webp.Decode(input)
	//	if err != nil {
	//		return nil, err
	//	}
	//} else {
	//	img, _, err = image.Decode(input)
	//	if err != nil {
	//		return nil, err
	//	}
	//}

	img = resize.Resize(128, 128, img, resize.Bicubic)

	var buf bytes.Buffer
	err = jpeg.Encode(&buf, img, nil)
	if err != nil {
		return nil, err
	}

	return bytes.NewReader(buf.Bytes()), nil
}

func (r *Remote) UploadThumbnail(ctx context.Context, doc model.Document) (model.Document, error) {
	doc, err := r.Get(ctx, doc)
	if err != nil {
		return doc, err
	}

	compressedContent, err := compressImage(bytes.NewReader(doc.ResponseContent), doc.Extension)
	if err != nil {
		return doc, err
	}

	doc.CompressedContent = compressedContent

	object := s3.PutObjectInput{
		Bucket:      aws.String(r.cfg.Bucket),
		Key:         aws.String(thumbnailKey(doc)),
		Body:        doc.CompressedContent,
		ContentType: aws.String(doc.Type),
		ACL:         aws.String("private"),
		Metadata: map[string]*string{
			"x-amz-meta-my-key": aws.String(doc.Path.String()),
		},
	}

	_, err = r.s3.PutObjectWithContext(ctx, &object)
	if err != nil {
		return doc, err
	}

	logrus.Infof("Thumbnail uploaded successfully with key: %s", thumbnailKey(doc))

	return doc, nil
}

func (r *Remote) GenerateThumbnail(doc model.Document, duration time.Duration) (string, error) {
	object := s3.GetObjectInput{
		Bucket: aws.String(r.cfg.Bucket),
		Key:    aws.String(thumbnailKey(doc)),
	}

	req, _ := r.s3.GetObjectRequest(&object)

	link, err := req.Presign(duration)
	if err != nil {
		return "", err
	}

	return link, nil

}
