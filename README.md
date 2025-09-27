# ORBAI Core — CAP + PostgreSQL 服务

版本：1.0.0  
日期：2025-09-27  
作者：ORBAICODER

---

本项目基于 SAP CAP（Cloud Application Programming Model）和 PostgreSQL，提供差旅与发票管理的 OData V4 服务，包含项目、差旅条目、发票、记账规则等领域模型与操作。你可以使用一键启动脚本快速在本地启动与验证服务。

- 基础 URL（本地示例）：http://localhost:5885
- 服务：/travel（差旅域）、/trbooking（记账规则域）
- API 详情：参见根目录 API_Documentation.md

## 目录
- 技术栈
- 仓库结构
- 快速开始
- 启动与常用脚本
- 环境变量与安全
- API 与测试
- 部署建议
- 常见问题
- 许可证与维护者

## 技术栈
- Node.js >= 18
- SAP CAP (@sap/cds 9.x)
- PostgreSQL（使用 @cap-js/postgres 驱动）
- Express + CORS（server.js 中集成）

## 仓库结构（节选）
- /db/schema.cds：领域模型（实体映射至既有 PostgreSQL 物理表）
- /srv/*.cds, /srv/*.js：服务定义与实现
- /server.js：CAP 启动引导（.env 加载、CORS 等）
- /start.sh：一键启动脚本（支持 start/watch、profile、port）
- /API_Documentation.md：OData API 说明
- /test_case.txt：已验证的 Action/Function 调用与示例
- /.cdsrc.json：CAP 运行时配置（包含 requires/db、auth 等）
- /.env.example：环境变量示例（请复制为 .env 并填写实际值）

## 快速开始
1) 准备环境
- 安装 Node.js 18+ 与 npm
- 准备可访问的 PostgreSQL 数据库（示例数据库名：ORBAICORE）

2) 安装依赖
- npm ci 或 npm install

3) 配置环境变量
- 复制 .env.example 为 .env，并填写数据库信息（PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE）
- 生产环境可设置 BASIC_ADMIN_PASSWORD、BASIC_VIEWER_PASSWORD（用于 server.js 动态注入 Basic 认证）

4) 启动服务（二选一）
- 使用脚本：./start.sh start --profile development --port 5885
- 开发/watch：./start.sh watch --profile development --port 5885

> 提示：start.sh 会自动加载 .env；端口可根据需要调整。

## 启动与常用脚本
- 一键脚本
  - ./start.sh start --profile production --port 5885
  - ./start.sh watch --profile development --port 5885
- npm scripts
  - npm run start（node server.js）
  - npm run serve（cds serve）
  - npm run build（cds build）
  - npm run deploy（cds deploy）
  - npm run dev（cds watch --with-mocks --in-memory）

## 环境变量与安全
- 请勿提交 .env，仓库已包含标准 .gitignore（忽略 .env 与其他敏感/生成文件）
- 推荐做法：使用 .env 或 CI/CD Secret 注入数据库与认证凭据
- 建议后续将 .cdsrc.json 中任何明文敏感信息迁移至环境变量（如需我来改造可提出 Issue）

## API 与测试
- API 文档：见 API_Documentation.md（包含实体、操作、函数与示例 curl）
- 已验证测试用例：见 test_case.txt（记录了成功的 ActionImports/FunctionImports 调用与返回）
- 元数据：/travel/$metadata、/trbooking/$metadata

示例（本地默认端口 5885）：
- GET http://localhost:5885/travel/invoices
- POST http://localhost:5885/travel/createInvoice
- GET http://localhost:5885/trbooking/getbookingrule()

## 部署建议
- 生产环境使用 start.sh start --profile production，并配置生产数据库
- 使用 Basic 认证（或接入更安全的身份方案），通过环境变量注入口令
- 建议在 GitHub 上开启分支保护、PR 审核、必需状态检查

## 常见问题
- 无法连接数据库：检查 .env 中 PGHOST、PGPORT、PGUSER、PGPASSWORD、PGDATABASE；确认数据库实例可达
- 401/403：在生产 profile 下，需提供 BASIC_ADMIN_PASSWORD/BASIC_VIEWER_PASSWORD 或切换到开发 profile（mocked auth）
- 端口冲突：使用 --port 指定其他端口（例如 5886）

## 许可证与维护者
- License：ISC（见 package.json）
- 维护者：ORBAICODER

---

如需我补充 Postman/REST Client 集合、一键清理测试数据脚本，或将 .cdsrc.json 中凭据改为环境变量注入，请直接提出任务。