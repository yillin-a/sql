<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>批量成绩录入 - ${course.hylCname10}</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        h2 {
            color: #333;
            border-bottom: 3px solid #667eea;
            padding-bottom: 15px;
            margin-bottom: 30px;
            font-size: 2.2em;
            text-align: center;
        }
        .sub-header {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
            font-size: 1.1em;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-weight: 600;
        }
        .alert-success {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }
        .alert-error {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        
        .batch-tools {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border: 1px solid #dee2e6;
        }
        .batch-tools h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 1.3em;
        }
        .tool-row {
            display: flex;
            gap: 15px;
            align-items: center;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }
        .tool-input {
            padding: 8px 12px;
            border: 2px solid #e9ecef;
            border-radius: 6px;
            font-size: 14px;
            width: 100px;
        }
        .tool-input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .course-info {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border: 1px solid #dee2e6;
        }
        .course-info h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 1.5em;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        .info-item {
            background: white;
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }
        .info-label {
            font-weight: 600;
            color: #6c757d;
            font-size: 12px;
            text-transform: uppercase;
            margin-bottom: 5px;
        }
        .info-value {
            font-size: 16px;
            color: #333;
            font-weight: 500;
        }
        
        .batch-form {
            background: white;
            padding: 0;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }
        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #e9ecef;
            vertical-align: middle;
        }
        th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
            position: sticky;
            top: 0;
        }
        tr:hover {
            background-color: #f1f3f5;
        }
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        
        .score-input {
            padding: 8px 12px;
            border: 2px solid #e9ecef;
            border-radius: 6px;
            font-size: 14px;
            text-align: center;
            width: 80px;
            transition: border-color 0.3s ease;
        }
        .score-input:focus {
            outline: none;
            border-color: #667eea;
        }
        .score-input.has-score {
            background-color: #e7f3ff;
            border-color: #007bff;
        }
        .score-input.no-score {
            background-color: #fff3cd;
            border-color: #ffc107;
        }
        .score-input.invalid {
            background-color: #f8d7da;
            border-color: #dc3545;
        }
        
        .score-display {
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: 600;
            min-width: 50px;
            display: inline-block;
        }
        .score-excellent {
            background-color: #d4edda;
            color: #155724;
        }
        .score-good {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        .score-average {
            background-color: #fff3cd;
            color: #856404;
        }
        .score-poor {
            background-color: #f8d7da;
            color: #721c24;
        }
        .score-none {
            background-color: #e2e3e5;
            color: #6c757d;
            font-style: italic;
        }
        
        .btn {
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            margin-right: 12px;
            margin-bottom: 10px;
            border: none;
            cursor: pointer;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .btn-warning {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
        }
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            color: white;
            text-decoration: none;
        }
        
        .actions {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        
        .no-data {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-style: italic;
            background-color: #f8f9fa;
            border-radius: 10px;
            margin: 20px 0;
        }
        
        @media (max-width: 768px) {
            .container { padding: 15px; }
            .info-grid { grid-template-columns: 1fr; }
            .tool-row { flex-direction: column; align-items: stretch; }
            table { font-size: 12px; }
            th, td { padding: 6px; }
            .score-input { width: 60px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📊 批量成绩录入</h2>
        <p class="sub-header">课程: <strong>${course.hylCname10}</strong> | 教学班编号: <strong>${teachingClassId}</strong></p>
        
        <!-- 显示成功或错误消息 -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                ✅ ${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ❌ ${error}
            </div>
        </c:if>
        
        <!-- 批量工具 -->
        <div class="batch-tools">
            <h3>🛠️ 批量操作工具</h3>
            <div class="tool-row">
                <label>批量设置成绩：</label>
                <input type="number" id="batchScore" class="tool-input" min="0" max="100" placeholder="0-100">
                <button type="button" onclick="applyBatchScore()" class="btn btn-secondary">应用到所有</button>
                <button type="button" onclick="applyBatchScoreToEmpty()" class="btn btn-secondary">应用到空白</button>
            </div>
            <div class="tool-row">
                <label>快速设置：</label>
                <button type="button" onclick="setBatchScore(85)" class="btn btn-secondary">优秀(85)</button>
                <button type="button" onclick="setBatchScore(75)" class="btn btn-secondary">良好(75)</button>
                <button type="button" onclick="setBatchScore(65)" class="btn btn-secondary">及格(65)</button>
                <button type="button" onclick="clearAllScores()" class="btn btn-warning">清空所有</button>
            </div>
        </div>
        
        <!-- 课程基本信息 -->
        <div class="course-info">
            <h3>📖 课程基本信息</h3>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">课程名称</div>
                    <div class="info-value">${course.hylCname10}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">课程类型</div>
                    <div class="info-value">${course.hylCtype10}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">学分</div>
                    <div class="info-value">${course.hylCcredit10}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">学时</div>
                    <div class="info-value">${course.hylChour10}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">考核方式</div>
                    <div class="info-value">${course.hylCtest10}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">选课人数</div>
                    <div class="info-value">${enrollments.size()} 人</div>
                </div>
            </div>
        </div>
        
        <c:choose>
            <c:when test="${empty enrollments}">
                <div class="no-data">
                    <h3>📭 该教学班没有学生</h3>
                    <p>当前教学班没有学生选课，无法录入成绩。</p>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 批量成绩录入表单 -->
                <form method="POST" action="${pageContext.request.contextPath}/score-entry/batch-update" class="batch-form">
                    <input type="hidden" name="teachingClassId" value="${teachingClassId}">
                    
                    <table>
                        <thead>
                            <tr>
                                <th>序号</th>
                                <th>学号</th>
                                <th>学生姓名</th>
                                <th>当前成绩</th>
                                <th>录入成绩</th>
                                <th>状态</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="enrollment" items="${enrollments}" varStatus="status">
                                <tr>
                                    <td>
                                        <strong style="color: #667eea;">
                                            ${status.index + 1}
                                        </strong>
                                    </td>
                                    <td>
                                        <strong style="color: #333;">
                                            ${enrollment.hylSno10}
                                        </strong>
                                    </td>
                                    <td>
                                        <strong style="color: #333;">
                                            <c:choose>
                                                <c:when test="${not empty enrollment.studentName}">
                                                    ${enrollment.studentName}
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #999;">未知</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty enrollment.hylEscore10}">
                                                <c:choose>
                                                    <c:when test="${enrollment.hylEscore10 >= 90}">
                                                        <span class="score-display score-excellent">${enrollment.hylEscore10}</span>
                                                    </c:when>
                                                    <c:when test="${enrollment.hylEscore10 >= 80}">
                                                        <span class="score-display score-good">${enrollment.hylEscore10}</span>
                                                    </c:when>
                                                    <c:when test="${enrollment.hylEscore10 >= 70}">
                                                        <span class="score-display score-average">${enrollment.hylEscore10}</span>
                                                    </c:when>
                                                    <c:when test="${enrollment.hylEscore10 >= 60}">
                                                        <span class="score-display score-average">${enrollment.hylEscore10}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="score-display score-poor">${enrollment.hylEscore10}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="score-display score-none">未录入</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <input type="number" name="score_${enrollment.hylSno10}" 
                                               value="${enrollment.hylEscore10}" 
                                               min="0" max="100" 
                                               class="score-input ${not empty enrollment.hylEscore10 ? 'has-score' : 'no-score'}"
                                               placeholder="0-100"
                                               onchange="updateInputStyle(this);">
                                    </td>
                                    <td>
                                        <span id="status_${enrollment.hylSno10}" class="status-indicator">
                                            <c:choose>
                                                <c:when test="${not empty enrollment.hylEscore10}">✅ 已录入</c:when>
                                                <c:otherwise>⏳ 待录入</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    
                    <div class="actions">
                        <button type="submit" class="btn btn-success">💾 批量保存所有成绩</button>
                        <button type="button" onclick="validateAllScores()" class="btn btn-warning">✅ 验证所有成绩</button>
                        <a href="${pageContext.request.contextPath}/score-entry/class?teachingClassId=${teachingClassId}" class="btn btn-primary">✏️ 逐个录入</a>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
        
        <!-- 操作按钮 -->
        <div class="actions">
            <a href="${pageContext.request.contextPath}/score-entry/" class="btn btn-warning">📋 返回教学班列表</a>
            <c:if test="${userType == 'admin'}">
                <a href="${pageContext.request.contextPath}/admin/home" class="btn btn-primary">🏠 管理员首页</a>
            </c:if>
            <c:if test="${userType == 'teacher'}">
                <a href="${pageContext.request.contextPath}/teacher/dashboard" class="btn btn-primary">🏠 教师首页</a>
            </c:if>
        </div>
    </div>
    
    <script>
        // 更新输入框样式
        function updateInputStyle(input) {
            const value = input.value;
            const studentId = input.name.split('_')[1];
            const statusSpan = document.getElementById('status_' + studentId);
            
            if (value === '') {
                input.className = 'score-input no-score';
                statusSpan.innerHTML = '⏳ 待录入';
                statusSpan.style.color = '#ffc107';
            } else {
                const score = parseInt(value);
                if (score >= 0 && score <= 100) {
                    input.className = 'score-input has-score';
                    statusSpan.innerHTML = '✅ 已填写';
                    statusSpan.style.color = '#28a745';
                } else {
                    input.className = 'score-input invalid';
                    statusSpan.innerHTML = '❌ 无效';
                    statusSpan.style.color = '#dc3545';
                }
            }
        }
        
        // 批量设置成绩
        function applyBatchScore() {
            const batchScore = document.getElementById('batchScore').value;
            if (batchScore === '' || batchScore < 0 || batchScore > 100) {
                alert('请输入有效的成绩（0-100）');
                return;
            }
            
            document.querySelectorAll('.score-input').forEach(input => {
                input.value = batchScore;
                updateInputStyle(input);
            });
        }
        
        // 批量设置成绩到空白
        function applyBatchScoreToEmpty() {
            const batchScore = document.getElementById('batchScore').value;
            if (batchScore === '' || batchScore < 0 || batchScore > 100) {
                alert('请输入有效的成绩（0-100）');
                return;
            }
            
            document.querySelectorAll('.score-input').forEach(input => {
                if (input.value === '') {
                    input.value = batchScore;
                    updateInputStyle(input);
                }
            });
        }
        
        // 设置批量成绩
        function setBatchScore(score) {
            document.getElementById('batchScore').value = score;
            applyBatchScore();
        }
        
        // 清空所有成绩
        function clearAllScores() {
            if (confirm('确定要清空所有成绩输入吗？')) {
                document.querySelectorAll('.score-input').forEach(input => {
                    input.value = '';
                    updateInputStyle(input);
                });
            }
        }
        
        // 验证所有成绩
        function validateAllScores() {
            const inputs = document.querySelectorAll('.score-input');
            let validCount = 0;
            let invalidCount = 0;
            let emptyCount = 0;
            
            inputs.forEach(input => {
                const value = input.value;
                if (value === '') {
                    emptyCount++;
                } else {
                    const score = parseInt(value);
                    if (score >= 0 && score <= 100) {
                        validCount++;
                    } else {
                        invalidCount++;
                    }
                }
            });
            
            let message = '验证结果：\n';
            message += '有效成绩：' + validCount + ' 个\n';
            message += '无效成绩：' + invalidCount + ' 个\n';
            message += '空白项：' + emptyCount + ' 个\n';
            message += '总计：' + inputs.length + ' 个学生';
            
            alert(message);
        }
    </script>
</body>
</html> 