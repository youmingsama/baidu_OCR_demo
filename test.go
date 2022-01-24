package main

import (
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"strings"
)

type easy struct {
	Access_token string `json:"access_token"` // 字段解释，可指json 字符串的名字

}

func main() {
	var token easy
	host := "https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=ak&client_secret=sk"
	Response, _ := http.Get(host)
	defer Response.Body.Close()
	body, _ := ioutil.ReadAll(Response.Body)
	kksk := string(body)
	err := json.Unmarshal([]byte(kksk), &token)
	if err != nil {
		fmt.Println("Unmarshal failed err",err)
	}

	str := token.Access_token
	request_url := "https://aip.baidubce.com/rest/2.0/ocr/v1/accurate_basic"
	req_url := request_url + "?access_token=" + str
	file_url, _ := ioutil.ReadFile("G:\\golangdemo\\src\\server\\水月雨.jpg")
	img := base64.StdEncoding.EncodeToString(file_url)
	str1 := "image=" + url.QueryEscape(img)
	request, err1 := http.Post(req_url, "application/x-www-form-urlencoded", strings.NewReader(str1))
	if err != nil {
		fmt.Println("request failed err",err1)
	}
	body, _ = ioutil.ReadAll(request.Body)
	fmt.Println(string(body))

}
