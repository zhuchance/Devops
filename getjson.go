package main

import (
	"encoding/json"
	"log"
	"os"

	"github.com/tealeg/xlsx"
)

type WeatherData struct {
	Data struct {
		TimeStamp          int64 `json:"timeStamp"`
		FetchTimeStamp     int64 `json:"fetchTimeStamp"`
		UpdateTimeStamp    int64 `json:"updateTimeStamp"`
		ProvinceName       string
		CityName           string
		CountyName         string
		LinkSeven          string
		CurrentWeather     string
		CurrentWeatherIcon string
		CurrentTemp        string
		CurrentAqiValue    string
		CurrentAqiLevel    string
		WeatherArr         []struct {
			Date     string
			Time     string
			DateInfo struct {
				Date             string
				Lunar            string
				TimeStamp        int64
				Festival         string
				WeatherSourceUrl string
			}
			Temp      string
			Wind      string
			Condition string
			Imgs      []string
			Link      string
			Pm25      string
			Pm25Url   string
		}
		WeatherType string
		Pslink      string
		Pollution   string
		Alarm       []struct {
			Type  string
			Level string
			Color string
		}
	} `json:"data"`
	Errno int    `json:"errno"`
	Msg   string `json:"msg"`
}

func main() {
	// 打开 JSON 文件
	jsonFile, err := os.Open("data.json")
	if err != nil {
		log.Fatalf("Failed to open JSON file: %v", err)
	}
	defer jsonFile.Close()

	// 解析 JSON 文件
	var weatherData WeatherData
	err = json.NewDecoder(jsonFile).Decode(&weatherData)
	if err != nil {
		log.Fatalf("Failed to decode JSON file: %v", err)
	}

	// 创建 Excel 文件
	file := xlsx.NewFile()
	sheet, err := file.AddSheet("Weather Data")
	if err != nil {
		log.Fatalf("Failed to add sheet: %v", err)
	}

	// 添加表头
	headerRow := sheet.AddRow()
	headerRow.AddCell().SetValue("Date")
	headerRow.AddCell().SetValue("Time")
	headerRow.AddCell().SetValue("Temperature")
	headerRow.AddCell().SetValue("Wind")
	headerRow.AddCell().SetValue("Condition")
	headerRow.AddCell().SetValue("PM2.5")

	// 添加数据
	for _, data := range weatherData.Data.WeatherArr {
		row := sheet.AddRow()
		row.AddCell().SetValue(data.Date)
		row.AddCell().SetValue(data.Time)
		row.AddCell().SetValue(data.Temp)
		row.AddCell().SetValue(data.Wind)
		row.AddCell().SetValue(data.Condition)
		row.AddCell().SetValue(data.Pm25)
	}

	// 保存文件
	err = file.Save("weather_data1.xlsx")
	if err != nil {
		log.Fatalf("Failed to save the Excel file: %v", err)
	}

	log.Println("Excel file created successfully.")
}
