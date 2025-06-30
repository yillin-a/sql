package org.example.demo111.controller;

import org.example.demo111.dao.StudentDAO;
import org.example.demo111.dao.TeacherDAO;
import org.example.demo111.dao.FacultyDAO;
import org.example.demo111.dao.CourseDAO;
import org.example.demo111.dao.EnrollmentDAO;
import org.example.demo111.model.Student;
import org.example.demo111.model.Teacher;
import org.example.demo111.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * 主页控制器 - 管理员首页
 */
@WebServlet("/admin/home")
public class HomeController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 检查用户登录状态和权限
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getUserType())) {
            // 非管理员用户重定向到相应的仪表板
            if ("student".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/student/dashboard");
            } else if ("teacher".equals(user.getUserType())) {
                response.sendRedirect(request.getContextPath() + "/teacher/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return;
        }
        
        try {
            // 获取统计数据
            StudentDAO studentDAO = new StudentDAO();
            TeacherDAO teacherDAO = new TeacherDAO();
            FacultyDAO facultyDAO = new FacultyDAO();
            CourseDAO courseDAO = new CourseDAO();
            
            // 学生统计
            List<Student> students = studentDAO.findAll();
            request.setAttribute("studentCount", students.size());
            
            // 生源地统计
            Map<String, Object> originStats = studentDAO.getOriginOverallStats();
            if (originStats != null && originStats.containsKey("totalOrigins")) {
                Object totalOrigins = originStats.get("totalOrigins");
                if (totalOrigins != null) {
                    request.setAttribute("originCount", totalOrigins);
                } else {
                    request.setAttribute("originCount", 0);
                }
            } else {
                request.setAttribute("originCount", 0);
            }
            
            // 教师统计
            List<Teacher> teachers = teacherDAO.findAll();
            request.setAttribute("teacherCount", teachers.size());
            
            // 学院统计
            List<Map<String, Object>> faculties = facultyDAO.getAllFaculties();
            request.setAttribute("facultyCount", faculties.size());
            
            // 课程统计
            List<org.example.demo111.model.Course> courses = courseDAO.findAll();
            request.setAttribute("courseCount", courses.size());
            
            // 选课统计
            EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
            List<org.example.demo111.model.Enrollment> enrollments = enrollmentDAO.findAll();
            request.setAttribute("enrollmentCount", enrollments.size());
            
            // 设置用户信息
            request.setAttribute("currentUser", user);
            
            // 转发到主页
            request.getRequestDispatcher("/WEB-INF/views/admin/home.jsp").forward(request, response);
            
        } catch (SQLException e) {
            // 如果数据库查询失败，设置默认值
            request.setAttribute("studentCount", 0);
            request.setAttribute("originCount", 0);
            request.setAttribute("teacherCount", 0);
            request.setAttribute("facultyCount", 0);
            request.setAttribute("courseCount", 0);
            request.setAttribute("enrollmentCount", 0);
            request.setAttribute("currentUser", user);
            
            // 转发到主页
            request.getRequestDispatcher("/WEB-INF/views/admin/home.jsp").forward(request, response);
        }
    }
} 