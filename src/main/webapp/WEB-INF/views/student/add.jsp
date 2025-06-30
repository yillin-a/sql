<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>添加学生</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container { 
            max-width: 800px; 
            margin: 0 auto; 
            background-color: white; 
            padding: 40px; 
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
        .form-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 25px;
            border: 1px solid #dee2e6;
        }
        .section-title {
            color: #495057;
            font-size: 1.3em;
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .form-row { 
            display: grid; 
            grid-template-columns: 1fr 1fr; 
            gap: 20px; 
            margin-bottom: 20px;
        }
        .form-group { 
            margin-bottom: 20px; 
        }
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: 600; 
            color: #495057;
            font-size: 14px;
        }
        .required::after {
            content: " *";
            color: #dc3545;
        }
        input, select, textarea { 
            width: 100%; 
            padding: 12px; 
            border: 2px solid #e9ecef; 
            border-radius: 8px; 
            font-size: 14px; 
            transition: all 0.3s ease;
            box-sizing: border-box;
        }
        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn { 
            padding: 15px 30px; 
            border: none; 
            border-radius: 8px; 
            font-size: 16px; 
            cursor: pointer; 
            margin-right: 15px; 
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; 
        }
        .btn-secondary { 
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white; 
        }
        .btn:hover { 
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .error { 
            color: #dc3545; 
            margin-top: 8px; 
            font-size: 14px; 
            background-color: #f8d7da;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #f5c6cb;
        }
        .success {
            color: #155724;
            margin-top: 8px;
            font-size: 14px;
            background-color: #d4edda;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #c3e6cb;
        }
        .form-actions {
            text-align: center; 
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid #e9ecef;
        }
        .help-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }
        .validation-error {
            border-color: #dc3545 !important;
        }
        .validation-error:focus {
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1) !important;
        }
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .container { padding: 20px; }
            .form-row { grid-template-columns: 1fr; }
            .form-actions { text-align: center; }
            .btn { display: block; margin: 10px auto; width: 200px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>➕ 添加新学生</h2>
        
        <c:if test="${not empty error}">
            <div class="error">❌ ${error}</div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="success">✅ ${success}</div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/student/add" method="post" id="addStudentForm">
            <!-- 基本信息 -->
            <div class="form-section">
                <div class="section-title">👤 基本信息</div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="hylSname10" class="required">姓名</label>
                        <input type="text" id="hylSname10" name="hylSname10" value="${student.hylSname10}" 
                               required maxlength="20" placeholder="请输入学生姓名">
                        <div class="help-text">请输入真实姓名，最多20个字符</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="hylSsex10" class="required">性别</label>
                        <select id="hylSsex10" name="hylSsex10" required>
                            <option value="">请选择性别</option>
                            <option value="男" ${student.hylSsex10 == '男' ? 'selected' : ''}>👨 男</option>
                            <option value="女" ${student.hylSsex10 == '女' ? 'selected' : ''}>👩 女</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="hylSbirth10" class="required">出生日期</label>
                        <input type="date" id="hylSbirth10" name="hylSbirth10" value="${student.hylSbirth10}" required>
                        <div class="help-text">请选择准确的出生日期</div>
                    </div>
                </div>
                
                <div class="form-group full-width">
                    <label for="hylSplace10" class="required">籍贯</label>
                    <input type="text" id="hylSplace10" name="hylSplace10" value="${student.hylSplace10}" 
                           required maxlength="50" placeholder="请输入籍贯，如：北京市、上海市等">
                    <div class="help-text">请输入省市区，如：北京市朝阳区</div>
                </div>
            </div>
            
            <!-- 联系信息 -->
            <div class="form-section">
                <div class="section-title">📞 联系信息</div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="hylSemail10">邮箱地址</label>
                        <input type="email" id="hylSemail10" name="hylSemail10" value="${student.hylSemail10}" 
                               placeholder="example@email.com" maxlength="100">
                        <div class="help-text">可选，用于接收重要通知</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="hylSphone10">手机号码</label>
                        <input type="tel" id="hylSphone10" name="hylSphone10" value="${student.hylSphone10}" 
                               placeholder="13800138000" maxlength="20" pattern="[0-9]{11}">
                        <div class="help-text">可选，11位手机号码</div>
                    </div>
                </div>
            </div>
            
            <!-- 学籍信息 -->
            <div class="form-section">
                <div class="section-title">🎓 学籍信息</div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="hylMno10" class="required">专业编号</label>
                        <select id="hylMno10" name="hylMno10" required>
                            <option value="">请选择专业</option>
                            <option value="200001" ${student.hylMno10 == 200001 ? 'selected' : ''}>200001 - 计算机科学与技术</option>
                            <option value="200002" ${student.hylMno10 == 200002 ? 'selected' : ''}>200002 - 软件工程</option>
                            <option value="200003" ${student.hylMno10 == 200003 ? 'selected' : ''}>200003 - 数学与应用数学</option>
                            <option value="200004" ${student.hylMno10 == 200004 ? 'selected' : ''}>200004 - 物理学</option>
                            <option value="200005" ${student.hylMno10 == 200005 ? 'selected' : ''}>200005 - 化学</option>
                            <option value="200006" ${student.hylMno10 == 200006 ? 'selected' : ''}>200006 - 汉语言文学</option>
                        </select>
                        <div class="help-text">请选择学生所属专业</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="hylAcno10" class="required">班级编号</label>
                        <select id="hylAcno10" name="hylAcno10" required>
                            <option value="">请选择班级</option>
                            <option value="300001" ${student.hylAcno10 == 300001 ? 'selected' : ''}>300001 - 计算机科学与技术2024级1班</option>
                            <option value="300002" ${student.hylAcno10 == 300002 ? 'selected' : ''}>300002 - 计算机科学与技术2024级2班</option>
                            <option value="300003" ${student.hylAcno10 == 300003 ? 'selected' : ''}>300003 - 软件工程2024级1班</option>
                            <option value="300004" ${student.hylAcno10 == 300004 ? 'selected' : ''}>300004 - 数学与应用数学2024级1班</option>
                            <option value="300005" ${student.hylAcno10 == 300005 ? 'selected' : ''}>300005 - 物理学2024级1班</option>
                            <option value="300006" ${student.hylAcno10 == 300006 ? 'selected' : ''}>300006 - 化学2024级1班</option>
                            <option value="300007" ${student.hylAcno10 == 300007 ? 'selected' : ''}>300007 - 汉语言文学2024级1班</option>
                        </select>
                        <div class="help-text">请选择学生所属班级</div>
                    </div>
                </div>
            </div>
            
            <!-- 备注信息 -->
            <div class="form-section">
                <div class="section-title">📝 备注信息</div>
                <div class="form-group full-width">
                    <label for="notes">备注</label>
                    <textarea id="notes" name="notes" rows="3" placeholder="请输入备注信息（可选）" maxlength="500"></textarea>
                    <div class="help-text">可选，最多500个字符</div>
                </div>
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">✅ 添加学生</button>
                <a href="${pageContext.request.contextPath}/student/list" class="btn btn-secondary">❌ 取消</a>
            </div>
        </form>
    </div>
    
    <script>
        // 表单验证
        document.getElementById('addStudentForm').addEventListener('submit', function(e) {
            let isValid = true;
            const requiredFields = document.querySelectorAll('[required]');
            
            // 清除之前的错误样式
            document.querySelectorAll('.validation-error').forEach(field => {
                field.classList.remove('validation-error');
            });
            
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    field.classList.add('validation-error');
                    isValid = false;
                } else {
                    field.classList.remove('validation-error');
                }
            });
            

            
            // 验证邮箱格式
            const email = document.getElementById('hylSemail10').value;
            if (email && !email.includes('@')) {
                document.getElementById('hylSemail10').classList.add('validation-error');
                isValid = false;
            }
            
            // 验证手机号码格式
            const phone = document.getElementById('hylSphone10').value;
            if (phone && !/^1[3-9]\d{9}$/.test(phone)) {
                document.getElementById('hylSphone10').classList.add('validation-error');
                isValid = false;
            }
            
            // 验证专业和班级选择
            const major = document.getElementById('hylMno10').value;
            const className = document.getElementById('hylAcno10').value;
            
            if (!major) {
                document.getElementById('hylMno10').classList.add('validation-error');
                isValid = false;
            }
            
            if (!className) {
                document.getElementById('hylAcno10').classList.add('validation-error');
                isValid = false;
            }
            
            if (!isValid) {
                e.preventDefault();
                alert('请检查表单中的错误信息！\n\n必填字段：姓名、性别、出生日期、籍贯、专业、班级\n可选字段：邮箱、手机号码、备注');
            }
        });
        
        // 实时验证
        document.querySelectorAll('input, select').forEach(field => {
            field.addEventListener('blur', function() {
                if (this.hasAttribute('required') && !this.value.trim()) {
                    this.classList.add('validation-error');
                } else {
                    this.classList.remove('validation-error');
                }
                
                // 特殊验证
                if (this.id === 'hylSemail10' && this.value && !this.value.includes('@')) {
                    this.classList.add('validation-error');
                }
                
                if (this.id === 'hylSphone10' && this.value && !/^1[3-9]\d{9}$/.test(this.value)) {
                    this.classList.add('validation-error');
                }
                

            });
            
            field.addEventListener('input', function() {
                if (this.classList.contains('validation-error')) {
                    this.classList.remove('validation-error');
                }
            });
        });
        

    </script>
</body>
</html> 