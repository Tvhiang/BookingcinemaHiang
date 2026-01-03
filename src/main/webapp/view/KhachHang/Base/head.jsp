<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>

<style>
  :root{
    --primary:#ec1380;
    --primaryHover:#c90f6d;
    --bg:#0f0a0d;
    --surface:#1e1216;
    --surface2:#26181d;
    --muted:rgba(255,255,255,.68);
    --border:rgba(255,255,255,.08);
  }
  body{ background:var(--bg); color:#fff; font-family:Inter,system-ui,-apple-system,Segoe UI,Roboto; }
  h1,h2,h3,h4,.font-display{ font-family:"Be Vietnam Pro",Inter,sans-serif; }

  .glass{
    background: rgba(30,18,22,.78);
    border:1px solid var(--border);
    border-radius: 22px;
    box-shadow: 0 12px 40px rgba(0,0,0,.45);
    backdrop-filter: blur(14px);
  }
  .glass-soft{
    background: rgba(38,24,29,.65);
    border:1px solid var(--border);
    border-radius: 18px;
  }
  .text-mutedx{ color: var(--muted); }

  .btn-primaryx{
    background: linear-gradient(135deg, var(--primary) 0%, #ff4d6d 100%);
    border: none;
    color:#fff;
    font-weight: 800;
  }
  .btn-primaryx:hover{ filter: brightness(.95); transform: translateY(-1px); }

  .btn-outline-lightx{
    border:1px solid rgba(255,255,255,.18);
    color:#fff;
    background: rgba(255,255,255,.04);
  }
  .btn-outline-lightx:hover{ background: rgba(255,255,255,.08); }

  .badge-soft{
    background: rgba(255,255,255,.05);
    border:1px solid rgba(255,255,255,.10);
    color:#fff;
    font-weight:700;
  }
  .badge-age{ background: rgba(255,165,0,.10); border:1px solid rgba(255,165,0,.25); color:#ffb020; font-weight:900; }

  .topbar{
    position: sticky; top:0; z-index: 1000;
    background: rgba(15,10,13,.82);
    border-bottom:1px solid rgba(255,255,255,.06);
    backdrop-filter: blur(14px);
  }
  .nav-linkx{ color: rgba(255,255,255,.75); font-weight:800; font-size:.95rem; }
  .nav-linkx:hover{ color:#fff; background: rgba(255,255,255,.06); border-radius: 12px; }
  .brand-dot{ width:10px; height:10px; border-radius: 99px; background: var(--primary); box-shadow:0 0 18px rgba(236,19,128,.5); }
</style>
