package main

import (
	"encoding/json"
	"fmt"
	"github.com/360EntSecGroup-Skylar/excelize"
	"io/ioutil"
	"os"
)

type VM struct {
	ID         int    `json:"id"`
	Name       string `json:"name"`
	Status     string `json:"status"`
	IP         string `json:"ip"`
	CPU        int    `json:"cpu"`
	Memory     int    `json:"memory"`
	Disk       int    `json:"disk"`
	OS         string `json:"os"`
	CreateTime string `json:"create_time"`
	UpdateTime string `json:"update_time"`
}

type Response struct {
	Code int    `json:"code"`
	Msg  string `json:"msg"`
	Data []VM   `json:"data"`
}

func main() {
	// 读取 JSON 文件
	jsonBytes, err := ioutil.ReadFile("vm.json")
	if err != nil {
		fmt.Println("Error reading JSON file:", err)
		os.Exit(1)
	}

	// 解析 JSON 数据
	var response Response
	err = json.Unmarshal(jsonBytes, &response)
	if err != nil {
		fmt.Println("Error unmarshaling JSON:", err)
		os.Exit(1)
	}

	// 创建新的 Excel 文件
	f := excelize.NewFile()

	// 设置表头
	f.SetCellValue("Sheet1", "A1", "ID")
	f.SetCellValue("Sheet1", "B1", "Name")
	f.SetCellValue("Sheet1", "C1", "Status")
	f.SetCellValue("Sheet1", "D1", "IP")
	f.SetCellValue("Sheet1", "E1", "CPU")
	f.SetCellValue("Sheet1", "F1", "Memory")
	f.SetCellValue("Sheet1", "G1", "Disk")
	f.SetCellValue("Sheet1", "H1", "OS")
	f.SetCellValue("Sheet1", "I1", "Create Time")
	f.SetCellValue("Sheet1", "J1", "Update Time")

	// 循环写入数据
	for i, vm := range response.Data {
		row := i + 2 // Start from row 2
		f.SetCellValue("Sheet1", fmt.Sprintf("A%d", row), vm.ID)
		f.SetCellValue("Sheet1", fmt.Sprintf("B%d", row), vm.Name)
		f.SetCellValue("Sheet1", fmt.Sprintf("C%d", row), vm.Status)
		f.SetCellValue("Sheet1", fmt.Sprintf("D%d", row), vm.IP)
		f.SetCellValue("Sheet1", fmt.Sprintf("E%d", row), vm.CPU)
		f.SetCellValue("Sheet1", fmt.Sprintf("F%d", row), vm.Memory)
		f.SetCellValue("Sheet1", fmt.Sprintf("G%d", row), vm.Disk)
		f.SetCellValue("Sheet1", fmt.Sprintf("H%d", row), vm.OS)
		f.SetCellValue("Sheet1", fmt.Sprintf("I%d", row), vm.CreateTime)
		f.SetCellValue("Sheet1", fmt.Sprintf("J%d", row), vm.UpdateTime)
	}

	// 保存 Excel 文件
	err = f.SaveAs("virtual_machines.xlsx")
	if err != nil {
		fmt.Println("Failed to save Excel file:", err)
		os.Exit(1)
	}

	fmt.Println("Excel file saved successfully.")
}
