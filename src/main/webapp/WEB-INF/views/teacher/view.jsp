<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>教师详情</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 20px; }
        .info-item { padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .info-label { font-weight: bold; color: #555; margin-bottom: 5px; }
        .info-value { color: #333; font-size: 16px; }
        .btn { padding: 10px 20px; text-decoration: none; border-radius: 5px; font-size: 14px; margin-right: 10px; display: inline-block; }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-warning { background-color: #ffc107; color: #212529; }
        .btn-danger { background-color: #dc3545; color: white; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .status-active { color: #28a745; font-weight: bold; }
        .status-inactive { color: #dc3545; font-weight: bold; }
        .title-professor { color: #dc3545; font-weight: bold; }
        .title-associate { color: #fd7e14; font-weight: bold; }
        .title-lecturer { color: #007bff; font-weight: bold; }
        .title-assistant { color: #6c757d; font-weight: bold; }
        .actions { text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; }
        .status-form { display: inline-block; margin-left: 10px; }
        .status-form select { padding: 5px; margin-right: 5px; border: 1px solid #ddd; border-radius: 3px; }
        .status-form button { padding: 5px 10px; background-color: #28a745; color: white; border: none; border-radius: 3px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="container">
        <h2>👨‍🏫 教师详情</h2>
        
        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">教师编号</div>
                <div class="info-value">${teacher.hylTno10}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">姓名</div>
                <div class="info-value">${teacher.hylTname10}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">性别</div>
                <div class="info-value">${teacher.hylTsex10}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">年龄</div>
                <div class="info-value">${teacher.hylTage10} 岁</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">出生日期</div>
                <div class="info-value">
                    <fmt:formatDate value="${teacher.hylTbirth10}" pattern="yyyy年MM月dd日"/>
                </div>
            </div>
            
            <div class="info-item">
                <div class="info-label">职称</div>
                <div class="info-value 
                    <c:choose>
                        <c:when test="${teacher.hylTtitle10 == '教授'}">title-professor</c:when>
                        <c:when test="${teacher.hylTtitle10 == '副教授'}">title-associate</c:when>
                        <c:when test="${teacher.hylTtitle10 == '讲师'}">title-lecturer</c:when>
                        <c:otherwise>title-assistant</c:otherwise>
                    </c:choose>
                ">${teacher.hylTtitle10}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">所属学院</div>
                <div class="info-value">${teacher.facultyName}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">邮箱</div>
                <div class="info-value">${teacher.hylTemail10}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">办公室</div>
                <div class="info-value">${teacher.hylToffice10}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">电话</div>
                <div class="info-value">${teacher.hylTphone10}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">入职时间</div>
                <div class="info-value">
                    <fmt:formatDate value="${teacher.hylTjoindate10}" pattern="yyyy年MM月dd日"/>
                </div>
            </div>
            
            <div class="info-item">
                <div class="info-label">当前状态</div>
                <div class="info-value ${teacher.hylTstatus10 == '在职' ? 'status-active' : 'status-inactive'}">
                    ${teacher.hylTstatus10}
                </div>
            </div>
        </div>
        
        <div class="actions">
            <a href="${pageContext.request.contextPath}/teacher/edit?id=${teacher.hylTno10}" class="btn btn-warning">编辑信息</a>
            <a href="${pageContext.request.contextPath}/teacher/list" class="btn btn-secondary">返回列表</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">返回首页</a>
            
            <div class="status-form">
                <form action="${pageContext.request.contextPath}/teacher/status" method="post">
                    <input type="hidden" name="id" value="${teacher.hylTno10}"/>
                    <select name="status">
                        <option value="在职" ${teacher.hylTstatus10 == '在职' ? 'selected' : ''}>在职</option>
                        <option value="离职" ${teacher.hylTstatus10 == '离职' ? 'selected' : ''}>离职</option>
                        <option value="退休" ${teacher.hylTstatus10 == '退休' ? 'selected' : ''}>退休</option>
                    </select>
                    <button type="submit">更新状态</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html> 