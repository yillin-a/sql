package org.example.demo111.controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.example.demo111.model.Student;
import org.example.demo111.service.EnrollmentService;
import org.example.demo111.service.StudentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 学生管理控制器
 */
@WebServlet("/student/*")
public class StudentController extends HttpServlet {
    private final StudentService studentService;
    private final EnrollmentService enrollmentService;
    private final SimpleDateFormat dateFormat;
    
    public StudentController() {
        this.studentService = new StudentService();
        this.enrollmentService = new EnrollmentService();
        this.dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || "/".equals(pathInfo) || "/list".equals(pathInfo)) {
                listStudents(request, response);
            } else if ("/add".equals(pathInfo)) {
                showAddStudentForm(request, response);
            } else if ("/view".equals(pathInfo)) {
                viewStudent(request, response);
            } else if ("/edit".equals(pathInfo)) {
                editStudent(request, response);
            } else if ("/search".equals(pathInfo)) {
                searchStudents(request, response);
            } else if ("/scores".equals(pathInfo)) {
                listStudentScores(request, response);
            } else if ("/ranking".equals(pathInfo)) {
                listStudentRanking(request, response);
            } else if ("/detail-scores".equals(pathInfo)) {
                viewStudentDetailScores(request, response);

            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if ("/add".equals(pathInfo)) {
                addStudent(request, response);
            } else if ("/update".equals(pathInfo)) {
                updateStudent(request, response);
            } else if ("/delete".equals(pathInfo)) {
                deleteStudent(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 列出所有学生
     */
    private void listStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Student> students = studentService.getAllStudents();
        request.setAttribute("students", students);
        request.getRequestDispatcher("/WEB-INF/views/student/list.jsp").forward(request, response);
    }
    
    /**
     * 显示添加学生表单
     */
    private void showAddStudentForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/student/add.jsp").forward(request, response);
    }
    
    /**
     * 查看学生详情
     */
    private void viewStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Integer studentId = Integer.parseInt(request.getParameter("id"));
        Student student = studentService.getStudentById(studentId);
        
        if (student == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "学生不存在");
            return;
        }
        
        request.setAttribute("student", student);
        request.getRequestDispatcher("/WEB-INF/views/student/view.jsp").forward(request, response);
    }
    
    /**
     * 编辑学生信息
     */
    private void editStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Integer studentId = Integer.parseInt(request.getParameter("id"));
        Student student = studentService.getStudentById(studentId);
        
        if (student == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "学生不存在");
            return;
        }
        
        request.setAttribute("student", student);
        request.getRequestDispatcher("/WEB-INF/views/student/edit.jsp").forward(request, response);
    }
    
    /**
     * 搜索学生
     */
    private void searchStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String status = request.getParameter("status");
        String gender = request.getParameter("gender");
        
        List<Student> students;
        
        if (name != null && !name.trim().isEmpty()) {
            students = studentService.searchStudentsByName(name);
        } else {
            students = studentService.getAllStudents();
        }
        
        // 应用状态过滤
        if (status != null && !status.trim().isEmpty()) {
            students = students.stream()
                .filter(student -> status.equals(student.getHylSstatus10()))
                .collect(java.util.stream.Collectors.toList());
        }
        
        // 应用性别过滤
        if (gender != null && !gender.trim().isEmpty()) {
            students = students.stream()
                .filter(student -> gender.equals(student.getHylSsex10()))
                .collect(java.util.stream.Collectors.toList());
        }
        
        request.setAttribute("students", students);
        request.setAttribute("searchName", name);
        request.setAttribute("searchStatus", status);
        request.setAttribute("searchGender", gender);
        request.getRequestDispatcher("/WEB-INF/views/student/list.jsp").forward(request, response);
    }
    
    /**
     * 列出学生成绩排名
     */
    private void listStudentScores(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("success call this\n");
        try {
            List<Student> students = studentService.getStudentsWithScores();
            System.out.println(students);
            request.setAttribute("students", students);
            request.getRequestDispatcher("/WEB-INF/views/student/scores.jsp").forward(request, response);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
    
    /**
     * 列出学生详细排名
     */
    private void listStudentRanking(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
        List<Map<String, Object>> rankings = studentService.getAllStudentsRanking();
        request.setAttribute("rankings", rankings);
        request.getRequestDispatcher("/WEB-INF/views/student/ranking.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 查看学生详细成绩
     */
    private void viewStudentDetailScores(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Integer studentId = Integer.parseInt(request.getParameter("id"));
        
        // 获取学生基本信息
        Student student = studentService.getStudentById(studentId);
        if (student == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "学生不存在");
            return;
        }
        
        // 获取学生详细成绩
        List<Map<String, Object>> scores = studentService.getStudentScores(studentId);
        
        // 获取学生成绩统计
        Map<String, Object> stats = studentService.getStudentScoreStats(studentId);
        
        request.setAttribute("student", student);
        request.setAttribute("scores", scores);
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/WEB-INF/views/student/detail-scores.jsp").forward(request, response);
    }
    
    /**
     * 添加学生
     */
    private void addStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            Student student = parseStudentFromRequest(request);
            
            if (!studentService.validateStudent(student)) {
                request.setAttribute("error", "学生信息验证失败，请检查输入数据");
                request.getRequestDispatcher("/WEB-INF/views/student/add.jsp").forward(request, response);
                return;
            }
            
            boolean success = studentService.addStudent(student);
            
            if (success) {
                // 添加成功提示，包含触发器信息
                String message = String.format("学生 %s 添加成功！学号：%d\n" +
                    "系统已自动为该学生创建登录账户：\n" +
                    "用户名：%d\n" +
                    "默认密码：Student@123\n" +
                    "请通知学生及时修改密码。", 
                    student.getHylSname10(), 
                    student.getHylSno10(),
                    student.getHylSno10());
                
                request.setAttribute("message", message);
                request.setAttribute("newStudent", student);
            } else {
                request.setAttribute("error", "添加学生失败，请重试");
            }
            
            // 重新加载学生列表
            listStudents(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "添加学生时发生错误: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/student/add.jsp").forward(request, response);
        }
    }
    
    /**
     * 更新学生信息
     */
    private void updateStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Student student = parseStudentFromRequest(request);
        
        if (!studentService.validateStudent(student)) {
            request.setAttribute("error", "学生信息验证失败");
            request.setAttribute("student", student);
            request.getRequestDispatcher("/WEB-INF/views/student/edit.jsp").forward(request, response);
            return;
        }
        
        boolean success = studentService.updateStudent(student);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/student/view?id=" + student.getHylSno10());
        } else {
            request.setAttribute("error", "更新学生信息失败");
            request.setAttribute("student", student);
            request.getRequestDispatcher("/WEB-INF/views/student/edit.jsp").forward(request, response);
        }
    }
    
    /**
     * 删除学生
     */
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Integer studentId = Integer.parseInt(request.getParameter("id"));
        boolean success = studentService.deleteStudent(studentId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/student/list");
        } else {
            request.setAttribute("error", "删除学生失败");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 从请求参数解析学生对象
     */
    private Student parseStudentFromRequest(HttpServletRequest request) {
        Student student = new Student();
        
        String studentIdStr = request.getParameter("hylSno10");
        if (studentIdStr != null && !studentIdStr.trim().isEmpty()) {
            student.setHylSno10(Integer.parseInt(studentIdStr));
        }
        

        
        student.setHylSname10(request.getParameter("hylSname10"));
        
        String birthStr = request.getParameter("hylSbirth10");
        if (birthStr != null && !birthStr.trim().isEmpty()) {
            try {
                Date birthDate = dateFormat.parse(birthStr);
                student.setHylSbirth10(birthDate);
                // 根据出生日期自动计算年龄
                student.setHylSage10(calculateAge(birthDate));
            } catch (ParseException e) {
                // 忽略日期解析错误
            }
        }
        
        student.setHylSplace10(request.getParameter("hylSplace10"));
        student.setHylSsex10(request.getParameter("hylSsex10"));
        
        // 处理可选字段
        String email = request.getParameter("hylSemail10");
        if (email != null && !email.trim().isEmpty()) {
            student.setHylSemail10(email.trim());
        } else {
            student.setHylSemail10(null);
        }
        
        String phone = request.getParameter("hylSphone10");
        if (phone != null && !phone.trim().isEmpty()) {
            student.setHylSphone10(phone.trim());
        } else {
            student.setHylSphone10(null);
        }
        
        String majorIdStr = request.getParameter("hylMno10");
        if (majorIdStr != null && !majorIdStr.trim().isEmpty()) {
            student.setHylMno10(Integer.parseInt(majorIdStr));
        }
        
        String classIdStr = request.getParameter("hylAcno10");
        if (classIdStr != null && !classIdStr.trim().isEmpty()) {
            student.setHylAcno10(Integer.parseInt(classIdStr));
        }
        
        return student;
    }
    
    /**
     * 根据出生日期计算年龄
     */
    private int calculateAge(Date birthDate) {
        if (birthDate == null) {
            return 0;
        }
        
        Calendar birth = Calendar.getInstance();
        birth.setTime(birthDate);
        
        Calendar now = Calendar.getInstance();
        
        int age = now.get(Calendar.YEAR) - birth.get(Calendar.YEAR);
        
        // 如果还没过生日，年龄减1
        if (now.get(Calendar.DAY_OF_YEAR) < birth.get(Calendar.DAY_OF_YEAR)) {
            age--;
        }
        
        return age;
    }
    

} 