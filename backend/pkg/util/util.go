package util

import (
	"database/sql"
	"fmt"
	"math/rand"
	"mime"
	"mime/multipart"
	"path/filepath"
	"regexp"
	"strconv"
	"time"

	"gitlab.com/eqshare/eqshare-back/model"
)

const timeFormat = "02-01-2006"

var TimeZone = time.FixedZone("UTC+5", 5*60*60)

func FormDataParse(user model.User, values *multipart.Form) (u model.User, err error) {
	var driverLicense model.DriverLicense

	user.FirstName = values.Value["first_name"][0]
	user.LastName = values.Value["last_name"][0]
	user.BirthDate, err = time.Parse(timeFormat, values.Value["birth_date"][0])
	if err != nil {
		return user, err
	}

	user.IIN = values.Value["iin"][0]
	driverLicense.LicenseNumber = values.Value["license_number"][0]
	driverLicense.ExpirationDate, err = time.Parse(timeFormat, values.Value["expiration_date"][0])
	if err != nil {
		return user, err
	}

	for _, file := range values.File["documents"] {
		var document model.Document
		content, err := file.Open()
		if err != nil {
			return user, err
		}

		if document.Title == "" {
			document.Title = file.Filename
		}

		document.RequestContent = content
		document.Size = file.Size
		document.Type, _, _ = mime.ParseMediaType(file.Header.Get("Content-AutoOrderType"))
		document.Extension = filepath.Ext(file.Filename)

		driverLicense.Documents = append(driverLicense.Documents, document)
		content.Close()
	}

	user.DriverLicense = &driverLicense

	return user, nil
}

func AdClientFormDataParse(client model.AdClient, values *multipart.Form) (ad model.AdClient, err error) {
	if len(values.Value["description"]) != 0 {
		client.Description = values.Value["description"][0]
	}

	if len(values.Value["headline"]) != 0 {
		client.Headline = values.Value["headline"][0]
	}

	if len(values.Value["price"]) != 0 {
		client.Price, err = strconv.ParseFloat(values.Value["price"][0], 64)
		if err != nil {
			return ad, err
		}
	}

	// if len(values.Value["id"]) != 0 {
	// 	client.ID, err = strconv.Atoi(values.Value["id"][0])
	// 	if err != nil {
	// 		return ad, err
	// 	}
	// }

	if len(values.Value["start_date"]) != 0 {
		client.StartDate, err = time.Parse(time.RFC3339, values.Value["start_date"][0])
		if err != nil {
			return ad, err
		}
	}

	if len(values.Value["end_date"]) != 0 {
		t, err := time.Parse(time.RFC3339, values.Value["end_date"][0])
		if err != nil {
			return ad, err
		}
		client.EndDate = model.Time{NullTime: sql.NullTime{Time: t, Valid: true}}
	}

	if len(values.Value["type_id"]) != 0 {
		client.TypeID, err = strconv.Atoi(values.Value["type_id"][0])
		if err != nil {
			return ad, err
		}
	}

	if len(values.Value["city_id"]) != 0 {
		client.CityID, err = strconv.Atoi(values.Value["city_id"][0])
		if err != nil {
			return ad, err
		}
	}

	for _, file := range values.File["documents"] {
		var document model.Document
		content, err := file.Open()
		if err != nil {
			return client, err
		}

		if document.Title == "" {
			document.Title = file.Filename
		}

		document.RequestContent = content
		document.Size = file.Size
		document.Type, _, _ = mime.ParseMediaType(file.Header.Get("Content-AutoOrderType"))
		document.UserID = client.UserID
		document.Extension = filepath.Ext(file.Filename)

		client.Documents = append(client.Documents, document)
		content.Close()
	}

	if len(values.Value["address"]) != 0 {
		client.Address = values.Value["address"][0]
	}

	if len(values.Value["latitude"]) != 0 {
		n, err := strconv.ParseFloat(values.Value["latitude"][0], 64)
		if err != nil {
			return client, err
		}
		client.Latitude = &n
	}

	if len(values.Value["longitude"]) != 0 {
		n, err := strconv.ParseFloat(values.Value["longitude"][0], 64)
		if err != nil {
			return client, err
		}
		client.Longitude = &n
	}

	return client, nil
}

func ParseDocumentOnMultipart(f *multipart.FileHeader) (d model.Document, err error) {
	content, err := f.Open()
	if err != nil {
		return
	}

	d.Title = f.Filename
	d.RequestContent = content
	d.Size = f.Size
	d.Type, _, _ = mime.ParseMediaType(f.Header.Get("Content-AutoOrderType"))
	d.Extension = filepath.Ext(f.Filename)

	return d, content.Close()
}

func CategoryParse(ct model.Type, values *multipart.Form) (model.Type, error) {
	ct.Name = values.Value["name"][0]
	if len(values.Value["id"]) > 0 {
		ct.ID, _ = strconv.Atoi(values.Value["id"][0])
	}

	for _, file := range values.File["documents"] {
		var document model.Document
		content, err := file.Open()
		if err != nil {
			return ct, err
		}

		if document.Title == "" {
			document.Title = file.Filename
		}

		document.RequestContent = content
		document.Size = file.Size
		document.Type, _, _ = mime.ParseMediaType(file.Header.Get("Content-AutoOrderType"))
		document.UserID = ct.UserID
		document.Extension = filepath.Ext(file.Filename)

		ct.Documents = append(ct.Documents, document)
		content.Close()
	}

	return ct, nil
}

func ParseDocuments(sb model.SubCategory, values *multipart.Form) (model.SubCategory, error) {
	for _, file := range values.File["documents"] {
		var document model.Document
		content, err := file.Open()
		if err != nil {
			return sb, err
		}

		if document.Title == "" {
			document.Title = file.Filename
		}

		document.RequestContent = content
		document.Size = file.Size
		document.Type, _, _ = mime.ParseMediaType(file.Header.Get("Content-AutoOrderType"))
		document.Extension = filepath.Ext(file.Filename)
		document.UserID = sb.UserID

		sb.Documents = append(sb.Documents, document)
		content.Close()
	}

	return sb, nil
}

func RateCalculation(rating float64, countRate, givenRate int) (float64, int) {
	rating = (rating*float64(countRate) + float64(givenRate)) / float64(countRate+1)
	countRate++

	return rating, countRate
}

func GenerateTemporaryPassword(length int) (string, error) {
	if length <= 0 {
		return "", nil
	}

	rand.Seed(time.Now().UnixNano())

	password := make([]byte, length)

	for i := 0; i < length; i++ {
		password[i] = byte(rand.Intn(10) + '0')
	}

	return string(password), nil
}

// ValidateAndFormatPhoneNumber validates and formats the phone number
func ValidateAndFormatPhoneNumber(phoneNumber string) (string, error) {
	// Use a regular expression to validate the phone number
	re := regexp.MustCompile(`^\+?(\d+)$`)
	matches := re.FindStringSubmatch(phoneNumber)
	if len(matches) != 2 {
		return "", fmt.Errorf("invalid phone number format")
	}

	// Remove the + from the beginning if it exists
	formattedNumber := matches[1]

	// Ensure the number starts with the country code (e.g., 7 for Kazakhstan)
	if len(formattedNumber) < 11 {
		return "", fmt.Errorf("phone number too short")
	}

	return formattedNumber, nil
}

func GenerateConfirmationCode() int {
	code := 0
	for i := 0; i < 6; i++ {
		code = code*10 + rand.Intn(10)
	}
	return code
}
