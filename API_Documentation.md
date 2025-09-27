<程序抬头>
文件名: API_Documentation.md
作者: ORBAICODER
版本: 1.0.1
日期: 2025-09-27
概要: 统一端口为 4004；本文件为 ORBAI Core - CAP PostgreSQL API 说明文档。
</程序抬头>

# ORBAI Core - CAP PostgreSQL API 文档

- 基础URL: `http://localhost:4004`
- 认证: 可选（如启用 JWT/SAP XSUAA 等，请在请求头中附带 Authorization）

## 服务一：Travel Service (`/travel`)

- 元数据URL: `http://localhost:4004/travel/$metadata`
- URL: `http://localhost:4004/travel/project`
- 示例 (GET): `curl http://localhost:4004/travel/project`
- URL: `http://localhost:4004/travel/travelentry`
- 示例 (GET): `curl http://localhost:4004/travel/travelentry`
- URL: `http://localhost:4004/travel/invoices`
- 示例 (GET): `curl http://localhost:4004/travel/invoices`
- URL: `http://localhost:4004/travel/createProject`
- 示例 (POST):

```
curl -X POST http://localhost:4004/travel/createProject -H "Content-Type: application/json" -d '{"projectid": "PROJ001", "customerid": "CUST001", "description": "New Project"}'
```

- URL: `http://localhost:4004/travel/createTravel`
- 示例 (POST):

```
curl -X POST http://localhost:4004/travel/createTravel -H "Content-Type: application/json" -d '{"travelid": "TR001", "userid": "USER01", "fromdate": "2025-01-01", "todate": "2025-01-05", "destination": "Shanghai", "projectid": "PROJ001"}'
```

- URL: `http://localhost:4004/travel/createInvoice`
- 示例 (POST):

```
curl -X POST http://localhost:4004/travel/createInvoice -H "Content-Type: application/json" -d '{"invoiceno": "INV001", "travelid": "TR001", "userid": "USER01", "invoicedate": "2025-01-10", "totalnetamount": 1000.00, "taxamount": 60.00, "grossamount": 1060.00, "bookingcode": "HOTL"}'
```

- URL: `http://localhost:4004/travel/getProjectByInvoice(invoiceno='...')`
- 示例:

```
curl "http://localhost:4004/travel/getProjectByInvoice(invoiceno='INV001')"
```

- URL: `http://localhost:4004/travel/getCustomerRelatedData(customerid='...')`
- 示例:

```
curl "http://localhost:4004/travel/getCustomerRelatedData(customerid='CUST001')"
```

- URL: `http://localhost:4004/travel/getInvoicesByTravel(travelid='...',userid='...')`
- 示例:

```
curl "http://localhost:4004/travel/getInvoicesByTravel(travelid='TR001',userid='USER01')"
```

## 服务二：TR Booking Service (`/trbooking`)

- 元数据URL: `http://localhost:4004/trbooking/$metadata`
- URL: `http://localhost:4004/trbooking/bookingrule`
- 示例 (GET):

```
curl "http://localhost:4004/trbooking/bookingrule"
```

- 示例 (GET with filter):

```
curl "http://localhost:4004/trbooking/bookingrule?$filter=code%20eq%20'HOTL'"
```

- URL: `http://localhost:4004/trbooking/getbookingrule()`
- 示例:

```
curl "http://localhost:4004/trbooking/getbookingrule()"
```
