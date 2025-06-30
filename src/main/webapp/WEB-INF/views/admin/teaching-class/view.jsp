<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>教学班详情</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #007bff;
        }
        .header h1 {
            color: #333;
            margin: 0;
        }
        .btn {
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            margin-right: 5px;
            border: none;
            cursor: pointer;
            display: inline-block;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        .btn-info {
            background-color: #17a2b8;
            color: white;
        }
        .btn:hover {
            opacity: 0.8;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }
        .info-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #007bff;
        }
        .info-section h3 {
            margin: 0 0 15px 0;
            color: #007bff;
            font-size: 18px;
        }
        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            padding: 8px 0;
            border-bottom: 1px solid #e9ecef;
        }
        .info-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        .info-label {
            font-weight: bold;
            color: #333;
            min-width: 120px;
        }
        .info-value {
            color: #666;
            flex: 1;
            text-align: right;
        }
        .badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge-primary { background-color: #007bff; color: white; }
        .badge-success { background-color: #28a745; color: white; }
        .badge-warning { background-color: #ffc107; color: #212529; }
        .badge-info { background-color: #17a2b8; color: white; }
        .badge-secondary { background-color: #6c757d; color: white; }
        .progress-bar {
            width: 100%;
            height: 20px;
            background-color: #e9ecef;
            border-radius: 10px;
            overflow: hidden;
            margin-top: 5px;
        }
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #007bff, #0056b3);
            border-radius: 10px;
            transition: width 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 12px;
            font-weight: bold;
        }
        .status-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 30px;
        }
        .status-card h2 {
            margin: 0 0 10px 0;
            font-size: 24px;
        }
        .status-card p {
            margin: 0;
            opacity: 0.9;
        }
        .course-type {
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 11px;
            color: white;
        }
        .type-required { background-color: #dc3545; }
        .type-elective { background-color: #007bff; }
        .type-general { background-color: #6f42c1; }
        .type-physical { background-color: #fd7e14; }
        .type-practice { background-color: #20c997; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>👁️ 教学班详情</h1>
            <div>
                <a href="${pageContext.request.contextPath}/admin/teaching-class/edit?id=${teachingClass.hylTcno10}" 
                   class="btn btn-warning">✏️ 编辑</a>
                <a href="${pageContext.request.contextPath}/admin/teaching-class/list" 
                   class="btn btn-info">📋 返回列表</a>
            </div>
        </div>

        <!-- 状态卡片 -->
        <div class="status-card">
            <h2>${teachingClass.hylTcname10}</h2>
            <p>教学班编号：${teachingClass.hylTcno10} | ${teachingClass.hylTcyear10}年第${teachingClass.hylTcterm10}学期</p>
        </div>

        <!-- 详细信息 -->
        <div class="info-grid">
            <!-- 基本信息 -->
            <div class="info-section">
                <h3>📋 基本信息</h3>
                <div class="info-item">
                    <span class="info-label">教学班编号:</span>
                    <span class="info-value">
                        <span class="badge badge-primary">${teachingClass.hylTcno10}</span>
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">教学班名称:</span>
                    <span class="info-value">${teachingClass.hylTcname10}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">学年:</span>
                    <span class="info-value">${teachingClass.hylTcyear10} 年</span>
                </div>
                <div class="info-item">
                    <span class="info-label">学期:</span>
                    <span class="info-value">
                        <span class="badge badge-${teachingClass.hylTcterm10 == 1 ? 'info' : teachingClass.hylTcterm10 == 2 ? 'success' : 'warning'}">
                            第${teachingClass.hylTcterm10}学期
                        </span>
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">班次编号:</span>
                    <span class="info-value">
                        <span class="badge badge-secondary">${teachingClass.hylTcbatch10}</span>
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">班级类型:</span>
                    <span class="info-value">
                        <span class="badge ${teachingClass.hylTcrepeat10 == '重修班' ? 'badge-warning' : 'badge-info'}">
                            ${teachingClass.hylTcrepeat10}
                        </span>
                    </span>
                </div>
            </div>

            <!-- 课程信息 -->
            <div class="info-section">
                <h3>📚 课程信息</h3>
                <div class="info-item">
                    <span class="info-label">课程名称:</span>
                    <span class="info-value">${teachingClass.courseName}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">课程类型:</span>
                    <span class="info-value">
                        <span class="course-type type-${teachingClass.courseType == '必修课' ? 'required' : teachingClass.courseType == '限选课' ? 'elective' : teachingClass.courseType == '通识课' ? 'general' : teachingClass.courseType == '体育课' ? 'physical' : 'practice'}">
                            ${teachingClass.courseType}
                        </span>
                    </span>
                </div>
                <c:if test="${teachingClass.courseCredit != null}">
                    <div class="info-item">
                        <span class="info-label">学分:</span>
                        <span class="info-value">${teachingClass.courseCredit} 分</span>
                    </div>
                </c:if>
                <c:if test="${teachingClass.courseHour != null}">
                    <div class="info-item">
                        <span class="info-label">学时:</span>
                        <span class="info-value">${teachingClass.courseHour} 小时</span>
                    </div>
                </c:if>
                <c:if test="${not empty teachingClass.testType}">
                    <div class="info-item">
                        <span class="info-label">考核方式:</span>
                        <span class="info-value">
                            <span class="badge ${teachingClass.testType == '考试' ? 'badge-primary' : 'badge-info'}">
                                ${teachingClass.testType}
                            </span>
                        </span>
                    </div>
                </c:if>
            </div>

            <!-- 教师信息 -->
            <div class="info-section">
                <h3>👨‍🏫 教师信息</h3>
                <div class="info-item">
                    <span class="info-label">授课教师:</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${not empty teachingClass.teacherName}">
                                <span class="badge badge-success">${teachingClass.teacherName}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-secondary">未分配</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>

            <!-- 学生信息 -->
            <div class="info-section">
                <h3>👥 学生信息</h3>
                <div class="info-item">
                    <span class="info-label">当前学生数:</span>
                    <span class="info-value">
                        <span class="badge badge-primary">${teachingClass.hylTccurstu10} 人</span>
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">最大容量:</span>
                    <span class="info-value">
                        <span class="badge badge-info">${teachingClass.hylTcmaxstu10} 人</span>
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">剩余名额:</span>
                    <span class="info-value">
                        <c:set var="remaining" value="${teachingClass.hylTcmaxstu10 - teachingClass.hylTccurstu10}"/>
                        <span class="badge ${remaining > 0 ? 'badge-success' : 'badge-warning'}">
                            ${remaining} 人
                        </span>
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">班级使用率:</span>
                    <div class="info-value" style="flex: 1; max-width: 150px;">
                        <c:set var="usageRate" value="${teachingClass.hylTcmaxstu10 > 0 ? (teachingClass.hylTccurstu10 * 100.0 / teachingClass.hylTcmaxstu10) : 0}"/>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: ${usageRate}%;">
                                <fmt:formatNumber value="${usageRate}" pattern="#.#"/>%
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 操作建议 -->
        <div class="info-section" style="margin-top: 20px;">
            <h3>💡 操作建议</h3>
            <div style="padding: 15px 0;">
                <c:choose>
                    <c:when test="${teachingClass.hylTccurstu10 == 0}">
                        <p style="color: #6c757d; margin: 0;">
                            📝 该教学班还没有学生选课，可以修改课程信息或删除教学班。
                        </p>
                    </c:when>
                    <c:when test="${teachingClass.hylTccurstu10 < teachingClass.hylTcmaxstu10 * 0.3}">
                        <p style="color: #856404; margin: 0;">
                            ⚠️ 该教学班选课人数较少，建议检查课程安排或进行宣传。
                        </p>
                    </c:when>
                    <c:when test="${teachingClass.hylTccurstu10 == teachingClass.hylTcmaxstu10}">
                        <p style="color: #155724; margin: 0;">
                            ✅ 该教学班已满员，可以考虑开设新的班次。
                        </p>
                    </c:when>
                    <c:otherwise>
                        <p style="color: #155724; margin: 0;">
                            👍 该教学班选课情况良好，运行正常。
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 快捷操作 -->
        <div style="text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
            <a href="${pageContext.request.contextPath}/admin/teaching-class/edit?id=${teachingClass.hylTcno10}" 
               class="btn btn-warning">✏️ 编辑教学班</a>
            <a href="${pageContext.request.contextPath}/score-entry/class?teachingClassId=${teachingClass.hylTcno10}" 
               class="btn btn-primary">📊 成绩管理</a>
            <a href="${pageContext.request.contextPath}/admin/teaching-class/list" 
               class="btn btn-info">📋 返回列表</a>
        </div>
    </div>
</body>
</html> 