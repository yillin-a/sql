<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>添加教学班</title>
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
        .header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #007bff;
        }
        .header h1 {
            color: #333;
            margin: 0;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .form-group textarea {
            height: 100px;
            resize: vertical;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0,123,255,0.3);
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .form-row-three {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 15px;
        }
        .btn {
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            margin-right: 10px;
            border: none;
            cursor: pointer;
            display: inline-block;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn:hover {
            opacity: 0.8;
        }
        .button-group {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .alert {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .form-help {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        .required {
            color: #dc3545;
        }
        .auto-fill-hint {
            background-color: #e7f3ff;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
            font-size: 13px;
            color: #0066cc;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>➕ 添加教学班</h1>
        </div>

        <!-- 显示错误消息 -->
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ❌ ${error}
            </div>
        </c:if>

        <div class="auto-fill-hint">
            💡 提示：选择课程和班次后，教学班名称会自动生成。您也可以手动修改。
        </div>

        <form action="${pageContext.request.contextPath}/admin/teaching-class/add" method="post" onsubmit="return validateForm()">
            <!-- 基本信息 -->
            <div class="form-group">
                <label for="courseId">所属课程 <span class="required">*</span></label>
                <select id="courseId" name="courseId" required onchange="updateTeachingClassName()">
                    <option value="">请选择课程</option>
                    <c:forEach var="course" items="${courses}">
                        <option value="${course.courseId}" 
                                data-name="${course.courseName}"
                                data-type="${course.courseType}">
                            ${course.courseName} (${course.courseType})
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="teacherId">授课教师 <span class="required">*</span></label>
                <select id="teacherId" name="teacherId" required>
                    <option value="">请选择教师</option>
                    <c:forEach var="teacher" items="${teachers}">
                        <option value="${teacher.teacherId}">
                            ${teacher.teacherName} 
                            <c:if test="${not empty teacher.title}">
                                (${teacher.title})
                            </c:if>
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="tcyear">学年 <span class="required">*</span></label>
                    <select id="tcyear" name="tcyear" required>
                        <option value="">请选择学年</option>
                        <c:forEach var="year" begin="2023" end="2030">
                            <option value="${year}" ${year == 2024 ? 'selected' : ''}>${year}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="tcterm">学期 <span class="required">*</span></label>
                    <select id="tcterm" name="tcterm" required>
                        <option value="">请选择学期</option>
                        <option value="1">第1学期</option>
                        <option value="2" selected>第2学期</option>
                        <option value="3">第3学期</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="tcbatch">班次编号 <span class="required">*</span></label>
                    <select id="tcbatch" name="tcbatch" required onchange="updateTeachingClassName()">
                        <option value="">请选择班次</option>
                        <option value="01" selected>01</option>
                        <option value="02">02</option>
                        <option value="03">03</option>
                        <option value="04">04</option>
                        <option value="05">05</option>
                    </select>
                    <div class="form-help">班次编号用于区分同一课程的不同班级</div>
                </div>
                <div class="form-group">
                    <label for="tcrepeat">班级类型 <span class="required">*</span></label>
                    <select id="tcrepeat" name="tcrepeat" required>
                        <option value="非重修班" selected>非重修班</option>
                        <option value="重修班">重修班</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="tcname">教学班名称 <span class="required">*</span></label>
                <input type="text" id="tcname" name="tcname" required maxlength="50" 
                       placeholder="请输入教学班名称">
                <div class="form-help">建议格式：课程名称-班次编号班，如"数据库原理-01班"</div>
            </div>

            <div class="form-group">
                <label for="tcmaxstu">最大学生数 <span class="required">*</span></label>
                <input type="number" id="tcmaxstu" name="tcmaxstu" required 
                       min="1" max="200" value="50">
                <div class="form-help">班级可容纳的最大学生人数</div>
            </div>

            <div class="button-group">
                <button type="submit" class="btn btn-primary">✅ 添加教学班</button>
                <a href="${pageContext.request.contextPath}/admin/teaching-class/list" class="btn btn-secondary">❌ 取消</a>
            </div>
        </form>
    </div>

    <script>
        function updateTeachingClassName() {
            const courseSelect = document.getElementById('courseId');
            const batchSelect = document.getElementById('tcbatch');
            const nameInput = document.getElementById('tcname');
            
            if (courseSelect.value && batchSelect.value) {
                const courseName = courseSelect.options[courseSelect.selectedIndex].getAttribute('data-name');
                const batch = batchSelect.value;
                const suggestedName = courseName + '-' + batch + '班';
                nameInput.value = suggestedName;
            }
        }

        function validateForm() {
            const courseId = document.getElementById('courseId').value;
            const teacherId = document.getElementById('teacherId').value;
            const tcyear = document.getElementById('tcyear').value;
            const tcterm = document.getElementById('tcterm').value;
            const tcbatch = document.getElementById('tcbatch').value;
            const tcname = document.getElementById('tcname').value.trim();
            const tcmaxstu = document.getElementById('tcmaxstu').value;

            if (!courseId) {
                alert('请选择课程');
                return false;
            }
            if (!teacherId) {
                alert('请选择授课教师');
                return false;
            }
            if (!tcyear) {
                alert('请选择学年');
                return false;
            }
            if (!tcterm) {
                alert('请选择学期');
                return false;
            }
            if (!tcbatch) {
                alert('请选择班次编号');
                return false;
            }
            if (!tcname) {
                alert('请输入教学班名称');
                return false;
            }
            if (!tcmaxstu || tcmaxstu <= 0) {
                alert('最大学生数必须大于0');
                return false;
            }

            return true;
        }

        // 页面加载时自动生成教学班名称
        document.addEventListener('DOMContentLoaded', function() {
            updateTeachingClassName();
        });
    </script>
</body>
</html> 