package org.example.demo111.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.demo111.model.Enrollment;
import org.example.demo111.service.EnrollmentService;
import org.example.demo111.service.CourseService;
import org.example.demo111.model.Course;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * 选课成绩管理控制器
 */
@WebServlet("/enrollment/*")
public class EnrollmentController extends HttpServlet {
    private final EnrollmentService enrollmentService;
    private final CourseService courseService;
    
    public EnrollmentController() {
        this.enrollmentService = new EnrollmentService();
        this.courseService = new CourseService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || "/".equals(pathInfo) || "/list".equals(pathInfo)) {
                listEnrollments(request, response);
            } else if ("/add".equals(pathInfo)) {
                showAddForm(request, response);
            } else if ("/edit".equals(pathInfo)) {
                showEditForm(request, response);
            } else if ("/view".equals(pathInfo)) {
                showEnrollmentDetails(request, response);
            } else if ("/delete".equals(pathInfo)) {
                deleteEnrollment(request, response);
            } else if ("/student".equals(pathInfo)) {
                getStudentScores(request, response);
            } else if ("/course".equals(pathInfo)) {
                getCourseScores(request, response);
            } else if ("/average".equals(pathInfo)) {
                getCourseAverageScores(request, response);
            } else if ("/analysis".equals(pathInfo)) {
                getScoreAnalysis(request, response);
            } else if ("/class-scores".equals(pathInfo)) {
                showClassScores(request, response);
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
                addEnrollment(request, response);
            } else if ("/update".equals(pathInfo)) {
                updateEnrollment(request, response);
            } else if ("/delete".equals(pathInfo)) {
                deleteEnrollment(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 列出所有选课记录
     */
    private void listEnrollments(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Enrollment> enrollments = enrollmentService.getAllEnrollments();
        request.setAttribute("enrollments", enrollments);
        request.getRequestDispatcher("/WEB-INF/views/enrollment/list.jsp").forward(request, response);
    }
    
    /**
     * 显示添加选课记录表单
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 直接转发到添加页面，不需要额外的数据准备
        request.getRequestDispatcher("/WEB-INF/views/enrollment/add.jsp").forward(request, response);
    }
    
    /**
     * 显示编辑选课记录表单
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String studentIdStr = request.getParameter("studentId");
        String teachingClassIdStr = request.getParameter("teachingClassId");
        
        if (studentIdStr == null || teachingClassIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "学号和教学班编号不能为空");
            return;
        }
        
        try {
            Integer studentId = Integer.parseInt(studentIdStr);
            Integer teachingClassId = Integer.parseInt(teachingClassIdStr);
            
            Enrollment enrollment = enrollmentService.getEnrollment(studentId, teachingClassId);
            if (enrollment == null) {
                request.setAttribute("error", "选课记录不存在");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("enrollment", enrollment);
            request.getRequestDispatcher("/WEB-INF/views/enrollment/edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "学号或教学班编号格式错误");
        }
    }
    
    /**
     * 显示选课记录详情
     */
    private void showEnrollmentDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String studentIdStr = request.getParameter("studentId");
        String teachingClassIdStr = request.getParameter("teachingClassId");
        
        if (studentIdStr == null || teachingClassIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "学号和教学班编号不能为空");
            return;
        }
        
        try {
            Integer studentId = Integer.parseInt(studentIdStr);
            Integer teachingClassId = Integer.parseInt(teachingClassIdStr);
            
            Enrollment enrollment = enrollmentService.getEnrollment(studentId, teachingClassId);
            if (enrollment == null) {
                request.setAttribute("error", "选课记录不存在");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("enrollment", enrollment);
            request.getRequestDispatcher("/WEB-INF/views/enrollment/view.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "学号或教学班编号格式错误");
        }
    }
    
    /**
     * 获取学生成绩
     */
    private void getStudentScores(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String studentIdStr = request.getParameter("studentId");
        if (studentIdStr == null || studentIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "学号不能为空");
            return;
        }
        
        Integer studentId = Integer.parseInt(studentIdStr);
        List<Enrollment> enrollments = enrollmentService.getStudentScores(studentId);
        double averageScore = enrollmentService.calculateStudentAverageScore(studentId);
        
        request.setAttribute("enrollments", enrollments);
        request.setAttribute("studentId", studentId);
        request.setAttribute("averageScore", averageScore);
        request.getRequestDispatcher("/WEB-INF/views/enrollment/student-scores.jsp").forward(request, response);
    }
    
    /**
     * 获取课程成绩
     */
    private void getCourseScores(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String courseName = request.getParameter("courseName");
        if (courseName == null || courseName.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "课程名称不能为空");
            return;
        }
        
        List<Enrollment> enrollments = enrollmentService.getScoresByCourseName(courseName);
        request.setAttribute("enrollments", enrollments);
        request.setAttribute("courseName", courseName);
        request.getRequestDispatcher("/WEB-INF/views/enrollment/course-scores.jsp").forward(request, response);
    }

    /**
     * 获取课程平均成绩
     */
    private void getCourseAverageScores(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String courseName = request.getParameter("courseName");
        List<Enrollment> enrollments;
        
        if (courseName != null && !courseName.trim().isEmpty()) {
            // 如果有搜索参数，按课程名称搜索
            enrollments = enrollmentService.getCourseAverageScoresByCourseName(courseName.trim());
        } else {
            // 否则获取所有课程的平均成绩
            enrollments = enrollmentService.getCourseAverageScores();
        }
        
        Enrollment overallStats = enrollmentService.getOverallStatistics();
        
        request.setAttribute("enrollments", enrollments);
        request.setAttribute("overallStats", overallStats);
        request.setAttribute("searchCourseName", courseName); // 保存搜索关键词用于回显
        request.getRequestDispatcher("/WEB-INF/views/enrollment/course-average.jsp").forward(request, response);
    }
    
    /**
     * 获取成绩分析统计
     */
    private void getScoreAnalysis(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Enrollment overallStats = enrollmentService.getOverallStatistics();
        
        request.setAttribute("overallStats", overallStats);
        request.getRequestDispatcher("/WEB-INF/views/enrollment/score-analysis.jsp").forward(request, response);
    }
    
    private void showClassScores(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        String tcnoStr = request.getParameter("tcno");
        if (tcnoStr == null || tcnoStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "教学班编号不能为空");
            return;
        }

        try {
            Integer teachingClassId = Integer.parseInt(tcnoStr);
            
            // 获取该教学班的所有学生选课记录
            List<Enrollment> enrollments = enrollmentService.findEnrollmentsByTeachingClassId(teachingClassId);
            
            // 获取课程信息以显示名称
            Course course = courseService.findByTeachingClassId(teachingClassId);
            
            request.setAttribute("enrollments", enrollments);
            request.setAttribute("course", course);
            request.setAttribute("teachingClassId", teachingClassId);
            request.getRequestDispatcher("/WEB-INF/views/enrollment/class-scores.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "教学班编号格式错误");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "数据库查询失败: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 添加选课记录
     */
    private void addEnrollment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            System.out.println("called");
        Enrollment enrollment = parseEnrollmentFromRequest(request);
        
        if (!enrollmentService.validateEnrollment(enrollment)) {
            request.setAttribute("error", "选课信息验证失败");
            request.setAttribute("enrollment", enrollment);
            request.getRequestDispatcher("/WEB-INF/views/enrollment/add.jsp").forward(request, response);
            return;
        }
        
        boolean success = enrollmentService.addEnrollment(enrollment);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/enrollment/list");
        } else {
            request.setAttribute("error", "添加选课记录失败");
            request.setAttribute("enrollment", enrollment);
            request.getRequestDispatcher("/WEB-INF/views/enrollment/add.jsp").forward(request, response);
        }}catch(Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 更新选课记录
     */
    private void updateEnrollment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Enrollment enrollment = parseEnrollmentFromRequest(request);

            boolean success = enrollmentService.updateEnrollment(enrollment);

            if (success) {
                // 更新成功后，重定向到详情页面
                response.sendRedirect(request.getContextPath() + "/enrollment/view?studentId="
                        + enrollment.getHylSno10() + "&teachingClassId=" + enrollment.getHylTcno10() + "&success=true");
            } else {
                request.setAttribute("error", "更新选课记录失败，请重试");
                request.setAttribute("enrollment", enrollment); // 用于回显数据
                request.getRequestDispatcher("/WEB-INF/views/enrollment/edit.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "更新时发生错误: " + e.getMessage());
            Enrollment enrollment = parseEnrollmentFromRequest(request); // 再次解析以回显
            request.setAttribute("enrollment", enrollment);
            request.getRequestDispatcher("/WEB-INF/views/enrollment/edit.jsp").forward(request, response);
        }
    }
    
    /**
     * 删除选课记录
     */
    private void deleteEnrollment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String studentIdStr = request.getParameter("studentId");
        String teachingClassIdStr = request.getParameter("teachingClassId");
        
        if (studentIdStr == null || teachingClassIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "学号和教学班编号不能为空");
            return;
        }
        
        Integer studentId = Integer.parseInt(studentIdStr);
        Integer teachingClassId = Integer.parseInt(teachingClassIdStr);
        
        boolean success = enrollmentService.deleteEnrollment(studentId, teachingClassId);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/enrollment/list");
        } else {
            request.setAttribute("error", "删除选课记录失败");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 从请求参数解析选课对象
     */
    private Enrollment parseEnrollmentFromRequest(HttpServletRequest request) {
        String studentIdStr = request.getParameter("studentId");
        if (studentIdStr == null || studentIdStr.isEmpty()){
            studentIdStr = request.getParameter("hylSno10");
        }
        String teachingClassIdStr = request.getParameter("teachingClassId");
        if(teachingClassIdStr == null || teachingClassIdStr.isEmpty()){
            teachingClassIdStr = request.getParameter("hylTcno10");
        }
        Integer score = null;
        if (request.getParameter("hylEscore10") != null && !request.getParameter("hylEscore10").isEmpty()) {
            score = Integer.parseInt(request.getParameter("hylEscore10"));
        }
        String status = request.getParameter("hylStatus10");

        Enrollment enrollment = new Enrollment();
        enrollment.setHylSno10(Integer.parseInt(studentIdStr));
        enrollment.setHylTcno10(Integer.parseInt(teachingClassIdStr));
        enrollment.setHylEscore10(score);
        enrollment.setHylStatus10(status);

        return enrollment;
    }
} 