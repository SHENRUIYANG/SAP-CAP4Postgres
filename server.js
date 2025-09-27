/**
 * @file CAP Server Bootstrap
 * 
 * 内容大纲：初始化 CAP 服务器，加载环境变量（.env），启用 CORS，并导出 cds.server；在启动日志中输出有效端口；生产环境下基于环境变量动态注入 Basic 认证。
 * 作者：ORBAICODER
 * 版本：V1.2.1
 * 日期：2025-09-27
 */

// 加载环境变量（不打印或泄露任何敏感信息）
require('dotenv').config();

const express = require('express');
const cds = require('@sap/cds');
const cors = require('cors');

// 基于环境变量注入 Basic 认证配置（仅生产模式），避免硬编码
(() => {
  const isProd = (process.env.NODE_ENV === 'production') ||
                 (process.env.CDS_ENV === 'production') ||
                 (process.env.CDS_PROFILE === 'production');
  if (isProd) {
    const adminPwd = process.env.BASIC_ADMIN_PASSWORD;
    const viewerPwd = process.env.BASIC_VIEWER_PASSWORD;
    if (adminPwd && viewerPwd) {
      cds.env.requires = cds.env.requires || {};
      cds.env.requires.auth = cds.env.requires.auth || {};
      cds.env.requires.auth.kind = 'basic';
      cds.env.requires.auth.users = {
        admin: { password: adminPwd, roles: ['admin', 'viewer', 'editor'] },
        viewer: { password: viewerPwd, roles: ['viewer'] }
      };
    }
  }
})();

// 挂载中间件（遵循现有风格，不做硬编码配置）
cds.on('bootstrap', (app) => {
    app.use(cors());
});

// 启动日志：打印有效端口（未设置则默认为 4004）
cds.on('served', () => {
  const effectivePort = process.env.PORT || 4004;
  console.log(`[CAP] Service served on port: ${effectivePort}`);
});

module.exports = cds.server;