package org.example.demo111.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.example.demo111.model.Course;
import org.example.demo111.model.User;
import org.example.demo111.service.CourseService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 课程管理控制器
 */
@WebServlet("/course/*")
public class CourseController extends HttpServlet {
    private final CourseService courseService;
    
    public CourseController() {
        this.courseService = new CourseService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || "/".equals(pathInfo) || "/list".equals(pathInfo)) {
                listCourses(request, response);
            } else if ("/view".equals(pathInfo)) {
                viewCourse(request, response);
            } else if ("/edit".equals(pathInfo)) {
                editCourse(request, response);
            } else if ("/search".equals(pathInfo)) {
                searchCourses(request, response);
            } else if ("/stats".equals(pathInfo)) {
                showCourseStats(request, response);
            } else if ("/score-stats".equals(pathInfo)) {
                showCourseScoreStats(request, response);
            } else if ("/average-scores".equals(pathInfo)) {
                showCourseAverageScores(request, response);
            } else if ("/teacher-stats".equals(pathInfo)) {
                showTeacherCourseStats(request, response);
            } else if ("/add".equals(pathInfo)) {
                showAddCourseForm(request, response);
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
                addCourse(request, response);
            } else if ("/update".equals(pathInfo)) {
                updateCourse(request, response);
            } else if ("/delete".equals(pathInfo)) {
                deleteCourse(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 列出课程 - 根据用户权限显示不同内容
     */
    private void listCourses(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        // 获取当前用户信息
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        List<Course> courses;
        
        // 根据用户类型显示不同的课程列表
        if ("admin".equals(currentUser.getUserType())) {
            // 管理员可以查看所有课程
            courses = courseService.getAllCourses();
        } else if ("teacher".equals(currentUser.getUserType())) {
            // 教师只能查看自己教授的课程
            try {
                Integer teacherId = currentUser.getUserId();
                courses = courseService.getCoursesByTeacherId(teacherId);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "用户ID格式错误，无法获取课程列表");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
        } else {
            // 其他用户类型（如学生）无权访问
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，无法访问课程管理页面");
            return;
        }
        
        request.setAttribute("courses", courses);
        request.setAttribute("userType", currentUser.getUserType());
        request.getRequestDispatcher("/WEB-INF/views/course/list.jsp").forward(request, response);
    }
    
    /**
     * 查看课程详情
     */
    private void viewCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        Integer courseId = Integer.parseInt(request.getParameter("id"));
        Course course = courseService.getCourseById(courseId);
        
        if (course == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "课程不存在");
            return;
        }
        
        request.setAttribute("course", course);
        request.getRequestDispatcher("/WEB-INF/views/course/view.jsp").forward(request, response);
    }
    
    /**
     * 编辑课程信息
     */
    private void editCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        Integer courseId = Integer.parseInt(request.getParameter("id"));
        Course course = courseService.getCourseById(courseId);
        
        if (course == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "课程不存在");
            return;
        }
        
        request.setAttribute("course", course);
        request.getRequestDispatcher("/WEB-INF/views/course/edit.jsp").forward(request, response);
    }
    
    /**
     * 搜索课程 - 根据用户权限显示不同内容
     */
    private void searchCourses(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        // 获取当前用户信息
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String name = request.getParameter("name");
        String type = request.getParameter("type");
        
        List<Course> courses;
        
        // 根据用户类型进行不同的搜索
        if ("admin".equals(currentUser.getUserType())) {
            // 管理员可以搜索所有课程
            if (name != null && !name.trim().isEmpty()) {
                courses = courseService.searchCoursesByName(name);
            } else if (type != null && !type.trim().isEmpty()) {
                courses = courseService.getCoursesByType(type);
            } else {
                courses = courseService.getAllCourses();
            }
        } else if ("teacher".equals(currentUser.getUserType())) {
            // 教师只能搜索自己教授的课程
            try {
                Integer teacherId = currentUser.getUserId();
                if (name != null && !name.trim().isEmpty()) {
                    courses = courseService.searchCoursesByNameAndTeacherId(name, teacherId);
                } else if (type != null && !type.trim().isEmpty()) {
                    courses = courseService.searchCoursesByTypeAndTeacherId(type, teacherId);
                } else {
                    courses = courseService.getCoursesByTeacherId(teacherId);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "用户ID格式错误，无法搜索课程");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
        } else {
            // 其他用户类型（如学生）无权访问
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，无法访问课程搜索功能");
            return;
        }
        
        request.setAttribute("courses", courses);
        request.setAttribute("searchName", name);
        request.setAttribute("searchType", type);
        request.setAttribute("userType", currentUser.getUserType());
        request.getRequestDispatcher("/WEB-INF/views/course/list.jsp").forward(request, response);
    }
    
    /**
     * 显示课程统计信息
     */
    private void showCourseStats(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        Map<String, Object> stats = courseService.getCourseStats();
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/WEB-INF/views/course/stats.jsp").forward(request, response);
    }
    
    /**
     * 显示课程成绩统计
     */
    private void showCourseScoreStats(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        List<Map<String, Object>> scoreStats = courseService.getCourseScoreStats();
        request.setAttribute("scoreStats", scoreStats);
        request.getRequestDispatcher("/WEB-INF/views/course/score-stats.jsp").forward(request, response);
    }
    
    /**
     * 显示课程平均成绩统计 - 根据用户权限显示不同内容
     */
    private void showCourseAverageScores(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        // 获取当前用户信息
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String courseName = request.getParameter("courseName");
        List<Map<String, Object>> scoreStats = new ArrayList<>(); // 初始化为空列表
        Map<String, Object> overallStats = null;
        
        // 根据用户类型显示不同的成绩统计
        if ("admin".equals(currentUser.getUserType())) {
            // 管理员可以查看所有课程的平均成绩统计
            if (courseName != null && !courseName.trim().isEmpty()) {
                scoreStats = courseService.getCourseAverageScoreByCourseName(courseName.trim());
            } else {
                scoreStats = courseService.getCourseAverageScoreDetails();
            }
            overallStats = courseService.getCourseAverageScoreOverallStats();
        } else if ("teacher".equals(currentUser.getUserType())) {
            // 教师只能查看自己教授课程的成绩统计
            System.out.println("currentUser: " + currentUser);
            try {
                Integer teacherId = currentUser.getUserId();
                System.out.println("teacherID: " + teacherId + ", courseName: " + courseName);
                if (courseName != null && !courseName.trim().isEmpty()) {
                    scoreStats = courseService.getCourseAverageScoreByTeacherIdAndCourseName(teacherId, courseName.trim());
                } else {
                    scoreStats = courseService.getCourseAverageScoreDetailsByTeacherId(teacherId);
                }
                // 教师不显示全局统计信息，只显示自己的课程统计
            } catch (Exception e) { // 捕获所有异常类型
                System.err.println("获取教师课程统计时出错: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "获取课程统计信息失败: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
        } else {
            // 其他用户类型无权访问
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，无法访问课程成绩统计页面");
            return;
        }
        
        request.setAttribute("scoreStats", scoreStats);
        request.setAttribute("overallStats", overallStats);
        request.setAttribute("searchCourseName", courseName);
        request.setAttribute("userType", currentUser.getUserType());
        request.getRequestDispatcher("/WEB-INF/views/course/average-scores.jsp").forward(request, response);
    }
    
    /**
     * 显示教师课程统计 - 仅限管理员访问
     */
    private void showTeacherCourseStats(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        // 获取当前用户信息
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // 检查用户权限，只有管理员才能访问教师课程统计
        if (!"admin".equals(currentUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，无法访问教师课程统计页面");
            return;
        }
        
        List<Map<String, Object>> teacherStats = courseService.getCourseAverageScoreByTeacher();
        request.setAttribute("teacherStats", teacherStats);
        request.getRequestDispatcher("/WEB-INF/views/course/teacher-stats.jsp").forward(request, response);
    }
    
    /**
     * 显示添加课程表单 - 仅限管理员访问
     */
    private void showAddCourseForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 获取当前用户信息
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // 检查用户权限，只有管理员才能添加课程
        if (!"admin".equals(currentUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，无法访问添加课程页面");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/course/add.jsp").forward(request, response);
    }
    
    /**
     * 添加课程
     */
    private void addCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        Course course = parseCourseFromRequest(request);
        
        try {
            boolean success = courseService.addCourse(course);
            if (success) {
                String message = URLEncoder.encode("添加成功", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/course/list?message=" + message);
            } else {
                request.setAttribute("error", "添加课程失败");
                request.getRequestDispatcher("/WEB-INF/views/course/add.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("course", course);
            request.getRequestDispatcher("/WEB-INF/views/course/add.jsp").forward(request, response);
        }
    }
    
    /**
     * 更新课程
     */
    private void updateCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        Course course = parseCourseFromRequest(request);
        
        try {
            boolean success = courseService.updateCourse(course);
            if (success) {
                String message = URLEncoder.encode("更新成功", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/course/list?message=" + message);
            } else {
                request.setAttribute("error", "更新课程失败，请重试");
                request.setAttribute("course", course);
                request.getRequestDispatcher("/WEB-INF/views/course/edit.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException | SQLException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("course", course);
            request.getRequestDispatcher("/WEB-INF/views/course/edit.jsp").forward(request, response);
        }
    }
    
    /**
     * 删除课程
     */
    private void deleteCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        Integer courseId = Integer.parseInt(request.getParameter("id"));
        
        try {
            boolean success = courseService.deleteCourse(courseId);
            if (success) {
                String message = URLEncoder.encode("删除成功", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/course/list?message=" + message);
            } else {
                String error = URLEncoder.encode("删除失败", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/course/list?error=" + error);
            }
        } catch (IllegalStateException e) {
            String error = URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/course/list?error=" + error);
        }
    }
    
    /**
     * 从请求参数解析课程对象
     */
    private Course parseCourseFromRequest(HttpServletRequest request) {
        String courseIdStr = request.getParameter("hylCno10");
        Course course = new Course();
        if (courseIdStr != null && !courseIdStr.isEmpty()) {
            course.setHylCno10(Integer.parseInt(courseIdStr));
        }

        course.setHylCname10(request.getParameter("hylCname10"));
        
        String creditStr = request.getParameter("hylCcredit10");
        if (creditStr != null && !creditStr.isEmpty()) {
            course.setHylCcredit10(new BigDecimal(creditStr));
        }
        
        String hourStr = request.getParameter("hylChour10");
        if (hourStr != null && !hourStr.isEmpty()) {
            course.setHylChour10(Integer.parseInt(hourStr));
        }
        
        course.setHylCtest10(request.getParameter("hylCtest10"));
        course.setHylCtype10(request.getParameter("hylCtype10"));
        course.setHylCprereq10(request.getParameter("hylCprereq10"));
        course.setHylCdesc10(request.getParameter("hylCdesc10"));
        
        return course;
    }
} 