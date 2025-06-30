<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>学生详情</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin: 20px 0;
        }
        .info-item {
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
            border-left: 4px solid #007bff;
        }
        .info-label {
            font-weight: bold;
            color: #555;
            margin-bottom: 5px;
        }
        .info-value {
            color: #333;
            font-size: 1.1em;
        }
        .actions {
            margin-top: 30px;
            text-align: center;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 0 10px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn:hover {
            opacity: 0.8;
        }
        .status-active {
            color: #28a745;
            font-weight: bold;
        }
        .status-inactive {
            color: #dc3545;
            font-weight: bold;
        }
        .success-message {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            border-left: 4px solid #28a745;
            white-space: pre-line;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>👤 学生详情</h2>
        
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="success-message">
                ✅ ${sessionScope.successMessage}
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        
        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">学号</div>
                <div class="info-value">${student.hylSno10}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">姓名</div>
                <div class="info-value">${student.hylSname10}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">性别</div>
                <div class="info-value">${student.hylSsex10}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">年龄</div>
                <div class="info-value">${student.hylSage10} 岁</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">出生日期</div>
                <div class="info-value">
                    <fmt:formatDate value="${student.hylSbirth10}" pattern="yyyy年MM月dd日"/>
                </div>
            </div>
            
            <div class="info-item">
                <div class="info-label">籍贯</div>
                <div class="info-value">${student.hylSplace10}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">邮箱</div>
                <div class="info-value">${student.hylSemail10}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">电话</div>
                <div class="info-value">${student.hylSphone10}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">入学时间</div>
                <div class="info-value">
                    <fmt:formatDate value="${student.hylSenrolldate10}" pattern="yyyy年MM月dd日"/>
                </div>
            </div>
            
            <div class="info-item">
                <div class="info-label">状态</div>
                <div class="info-value">
                    <span class="${student.hylSstatus10 == '在读' ? 'status-active' : 'status-inactive'}">
                        ${student.hylSstatus10}
                    </span>
                </div>
            </div>
            
            <div class="info-item">
                <div class="info-label">已修学分</div>
                <div class="info-value">${student.hylScreditsum10} 学分</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">GPA</div>
                <div class="info-value">${student.hylSgpa10}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">专业排名</div>
                <div class="info-value">第 ${student.hylSrank10} 名</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">专业</div>
                <div class="info-value">${student.majorName}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">班级</div>
                <div class="info-value">${student.className}</div>
            </div>
        </div>
        
        <div class="actions">
            <a href="${pageContext.request.contextPath}/student/edit?id=${student.hylSno10}" class="btn btn-warning">编辑信息</a>
            <a href="${pageContext.request.contextPath}/enrollment/student?studentId=${student.hylSno10}" class="btn btn-primary">查看成绩</a>
            <a href="${pageContext.request.contextPath}/student/list" class="btn btn-primary">返回列表</a>
            <form action="${pageContext.request.contextPath}/student/delete" method="post" style="display:inline;">
                <input type="hidden" name="id" value="${student.hylSno10}"/>
                <button type="submit" class="btn btn-danger" onclick="return confirm('确定要删除这个学生吗？此操作不可恢复！')">删除学生</button>
            </form>
        </div>
    </div>
</body>
</html> 