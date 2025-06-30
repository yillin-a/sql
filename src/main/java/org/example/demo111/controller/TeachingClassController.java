package org.example.demo111.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

import org.example.demo111.model.TeachingClass;
import org.example.demo111.model.User;
import org.example.demo111.service.TeachingClassService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 教学班控制器
 */
@WebServlet("/admin/teaching-class/*")
public class TeachingClassController extends HttpServlet {
    private TeachingClassService teachingClassService;

    @Override
    public void init() throws ServletException {
        teachingClassService = new TeachingClassService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 检查管理员权限
        if (!checkAdminPermission(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/";
        }

        try {
            switch (pathInfo) {
                case "/":
                case "/list":
                    listTeachingClasses(request, response);
                    break;
                case "/add":
                    showAddForm(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/view":
                    viewTeachingClass(request, response);
                    break;
                case "/search":
                    searchTeachingClasses(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 检查管理员权限
        if (!checkAdminPermission(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/";
        }

        try {
            switch (pathInfo) {
                case "/add":
                    addTeachingClass(request, response);
                    break;
                case "/update":
                    updateTeachingClass(request, response);
                    break;
                case "/delete":
                    deleteTeachingClass(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    /**
     * 检查管理员权限
     */
    private boolean checkAdminPermission(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    /**
     * 显示教学班列表
     */
    private void listTeachingClasses(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<TeachingClass> teachingClasses = teachingClassService.getAllTeachingClasses();
        Map<String, Object> stats = teachingClassService.getTeachingClassStats();
        
        request.setAttribute("teachingClasses", teachingClasses);
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/WEB-INF/views/admin/teaching-class/list.jsp").forward(request, response);
    }

    /**
     * 显示添加教学班表单
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Map<String, Object>> courses = teachingClassService.getAvailableCourses();
        List<Map<String, Object>> teachers = teachingClassService.getAvailableTeachers();
        
        request.setAttribute("courses", courses);
        request.setAttribute("teachers", teachers);
        request.getRequestDispatcher("/WEB-INF/views/admin/teaching-class/add.jsp").forward(request, response);
    }

    /**
     * 显示编辑教学班表单
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Integer id = Integer.parseInt(request.getParameter("id"));
        TeachingClass teachingClass = teachingClassService.getTeachingClassById(id);
        
        if (teachingClass == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "教学班不存在");
            return;
        }
        
        List<Map<String, Object>> courses = teachingClassService.getAvailableCourses();
        List<Map<String, Object>> teachers = teachingClassService.getAvailableTeachers();
        
        request.setAttribute("teachingClass", teachingClass);
        request.setAttribute("courses", courses);
        request.setAttribute("teachers", teachers);
        request.getRequestDispatcher("/WEB-INF/views/admin/teaching-class/edit.jsp").forward(request, response);
    }

    /**
     * 查看教学班详情
     */
    private void viewTeachingClass(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Integer id = Integer.parseInt(request.getParameter("id"));
        TeachingClass teachingClass = teachingClassService.getTeachingClassById(id);
        
        if (teachingClass == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "教学班不存在");
            return;
        }
        
        request.setAttribute("teachingClass", teachingClass);
        request.getRequestDispatcher("/WEB-INF/views/admin/teaching-class/view.jsp").forward(request, response);
    }

    /**
     * 搜索教学班
     */
    private void searchTeachingClasses(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        List<TeachingClass> teachingClasses = teachingClassService.searchTeachingClasses(keyword);
        Map<String, Object> stats = teachingClassService.getTeachingClassStats();
        
        request.setAttribute("teachingClasses", teachingClasses);
        request.setAttribute("stats", stats);
        request.setAttribute("searchKeyword", keyword);
        request.getRequestDispatcher("/WEB-INF/views/admin/teaching-class/list.jsp").forward(request, response);
    }

    /**
     * 添加教学班
     */
    private void addTeachingClass(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            TeachingClass teachingClass = parseTeachingClassFromRequest(request);
            boolean success = teachingClassService.addTeachingClass(teachingClass);
            
            if (success) {
                String message = URLEncoder.encode("添加教学班成功", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/admin/teaching-class/list?message=" + message);
            } else {
                request.setAttribute("error", "添加教学班失败");
                showAddForm(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            showAddForm(request, response);
        }
    }

    /**
     * 更新教学班
     */
    private void updateTeachingClass(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            TeachingClass teachingClass = parseTeachingClassFromRequest(request);
            teachingClass.setHylTcno10(Integer.parseInt(request.getParameter("id")));
            
            boolean success = teachingClassService.updateTeachingClass(teachingClass);
            
            if (success) {
                String message = URLEncoder.encode("更新教学班成功", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/admin/teaching-class/list?message=" + message);
            } else {
                request.setAttribute("error", "更新教学班失败");
                showEditForm(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            showEditForm(request, response);
        }
    }

    /**
     * 删除教学班
     */
    private void deleteTeachingClass(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            Integer id = Integer.parseInt(request.getParameter("id"));
            boolean success = teachingClassService.deleteTeachingClass(id);
            
            if (success) {
                String message = URLEncoder.encode("删除教学班成功", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/admin/teaching-class/list?message=" + message);
            } else {
                request.setAttribute("error", "删除教学班失败");
                listTeachingClasses(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            listTeachingClasses(request, response);
        }
    }

    /**
     * 从请求参数解析教学班对象
     */
    private TeachingClass parseTeachingClassFromRequest(HttpServletRequest request) {
        TeachingClass teachingClass = new TeachingClass();
        
        teachingClass.setHylTcname10(request.getParameter("tcname"));
        teachingClass.setHylTcyear10(Integer.parseInt(request.getParameter("tcyear")));
        teachingClass.setHylTcterm10(Integer.parseInt(request.getParameter("tcterm")));
        teachingClass.setHylTcrepeat10(request.getParameter("tcrepeat"));
        teachingClass.setHylTcbatch10(request.getParameter("tcbatch"));
        teachingClass.setHylTcmaxstu10(Integer.parseInt(request.getParameter("tcmaxstu")));
        teachingClass.setHylCno10(Integer.parseInt(request.getParameter("courseId")));
        teachingClass.setHylTno10(Integer.parseInt(request.getParameter("teacherId")));
        
        // 当前学生数默认为0
        teachingClass.setHylTccurstu10(0);
        
        return teachingClass;
    }
} 