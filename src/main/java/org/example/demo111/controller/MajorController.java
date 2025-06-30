package org.example.demo111.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.example.demo111.model.Major;
import org.example.demo111.model.User;
import org.example.demo111.service.MajorService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 专业管理控制器
 */
@WebServlet("/admin/major/*")
public class MajorController extends HttpServlet {
    private MajorService majorService;
    
    @Override
    public void init() throws ServletException {
        majorService = new MajorService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 权限检查
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，只有管理员可以管理专业");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
                listMajors(request, response);
            } else if (pathInfo.equals("/add")) {
                showAddMajorForm(request, response);
            } else if (pathInfo.equals("/edit")) {
                showEditMajorForm(request, response);
            } else if (pathInfo.equals("/view")) {
                viewMajor(request, response);
            } else if (pathInfo.equals("/search")) {
                searchMajors(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "操作失败：" + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 权限检查
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，只有管理员可以管理专业");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo.equals("/add")) {
                addMajor(request, response);
            } else if (pathInfo.equals("/edit")) {
                updateMajor(request, response);
            } else if (pathInfo.equals("/delete")) {
                deleteMajor(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "操作失败：" + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示专业列表
     */
    private void listMajors(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Major> majors = majorService.getAllMajors();
        Map<String, Object> statistics = majorService.getMajorStatistics();
        List<Map<String, Object>> facultyDistribution = majorService.getFacultyMajorDistribution();
        List<Map<String, Object>> faculties = majorService.getAllFaculties();
        
        request.setAttribute("majors", majors);
        request.setAttribute("statistics", statistics);
        request.setAttribute("facultyDistribution", facultyDistribution);
        request.setAttribute("faculties", faculties);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/major/list.jsp").forward(request, response);
    }
    
    /**
     * 显示添加专业表单
     */
    private void showAddMajorForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Map<String, Object>> faculties = majorService.getAllFaculties();
        request.setAttribute("faculties", faculties);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/major/add.jsp").forward(request, response);
    }
    
    /**
     * 添加专业
     */
    private void addMajor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // 获取表单数据
        String majorName = request.getParameter("hylMname10");
        String degree = request.getParameter("hylMdegree10");
        String yearsStr = request.getParameter("hylMyears10");
        String facultyIdStr = request.getParameter("hylFno10");
        
        try {
            Integer years = Integer.parseInt(yearsStr);
            Integer facultyId = Integer.parseInt(facultyIdStr);
            
            // 创建专业对象
            Major major = new Major();
            major.setHylMname10(majorName);
            major.setHylMdegree10(degree);
            major.setHylMyears10(years);
            major.setHylFno10(facultyId);
            
            // 添加专业
            String[] errorMessage = new String[1];
            boolean success = majorService.addMajor(major, errorMessage);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/major/list?success=专业添加成功");
            } else {
                // 重新显示表单并显示错误信息
                request.setAttribute("error", errorMessage[0]);
                request.setAttribute("major", major);
                
                List<Map<String, Object>> faculties = majorService.getAllFaculties();
                request.setAttribute("faculties", faculties);
                
                request.getRequestDispatcher("/WEB-INF/views/admin/major/add.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "请输入有效的数字");
            request.setAttribute("major", createMajorFromRequest(request));
            
            List<Map<String, Object>> faculties = majorService.getAllFaculties();
            request.setAttribute("faculties", faculties);
            
            request.getRequestDispatcher("/WEB-INF/views/admin/major/add.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示编辑专业表单
     */
    private void showEditMajorForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少专业编号参数");
            return;
        }
        
        try {
            Integer majorId = Integer.parseInt(idStr);
            Major major = majorService.getMajorById(majorId);
            
            if (major == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "专业不存在");
                return;
            }
            
            List<Map<String, Object>> faculties = majorService.getAllFaculties();
            
            request.setAttribute("major", major);
            request.setAttribute("faculties", faculties);
            
            request.getRequestDispatcher("/WEB-INF/views/admin/major/edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "专业编号格式错误");
        }
    }
    
    /**
     * 更新专业信息
     */
    private void updateMajor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String idStr = request.getParameter("hylMno10");
        String majorName = request.getParameter("hylMname10");
        String degree = request.getParameter("hylMdegree10");
        String yearsStr = request.getParameter("hylMyears10");
        String facultyIdStr = request.getParameter("hylFno10");
        
        try {
            Integer majorId = Integer.parseInt(idStr);
            Integer years = Integer.parseInt(yearsStr);
            Integer facultyId = Integer.parseInt(facultyIdStr);
            
            // 创建专业对象
            Major major = new Major();
            major.setHylMno10(majorId);
            major.setHylMname10(majorName);
            major.setHylMdegree10(degree);
            major.setHylMyears10(years);
            major.setHylFno10(facultyId);
            
            // 更新专业
            String[] errorMessage = new String[1];
            boolean success = majorService.updateMajor(major, errorMessage);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/major/list?success=专业信息更新成功");
            } else {
                // 重新显示表单并显示错误信息
                request.setAttribute("error", errorMessage[0]);
                request.setAttribute("major", major);
                
                List<Map<String, Object>> faculties = majorService.getAllFaculties();
                request.setAttribute("faculties", faculties);
                
                request.getRequestDispatcher("/WEB-INF/views/admin/major/edit.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "请输入有效的数字");
            
            Major major = createMajorFromRequest(request);
            request.setAttribute("major", major);
            
            List<Map<String, Object>> faculties = majorService.getAllFaculties();
            request.setAttribute("faculties", faculties);
            
            request.getRequestDispatcher("/WEB-INF/views/admin/major/edit.jsp").forward(request, response);
        }
    }
    
    /**
     * 查看专业详情
     */
    private void viewMajor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少专业编号参数");
            return;
        }
        
        try {
            Integer majorId = Integer.parseInt(idStr);
            Major major = majorService.getMajorById(majorId);
            
            if (major == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "专业不存在");
                return;
            }
            
            request.setAttribute("major", major);
            request.getRequestDispatcher("/WEB-INF/views/admin/major/view.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "专业编号格式错误");
        }
    }
    
    /**
     * 删除专业
     */
    private void deleteMajor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            response.getWriter().write("error:缺少专业编号参数");
            return;
        }
        
        try {
            Integer majorId = Integer.parseInt(idStr);
            
            String[] errorMessage = new String[1];
            boolean success = majorService.deleteMajor(majorId, errorMessage);
            
            if (success) {
                response.getWriter().write("success:专业删除成功");
            } else {
                response.getWriter().write("error:" + errorMessage[0]);
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("error:专业编号格式错误");
        }
    }
    
    /**
     * 搜索专业
     */
    private void searchMajors(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String facultyIdStr = request.getParameter("facultyId");
        
        Integer facultyId = null;
        if (facultyIdStr != null && !facultyIdStr.trim().isEmpty() && !facultyIdStr.equals("0")) {
            try {
                facultyId = Integer.parseInt(facultyIdStr);
            } catch (NumberFormatException e) {
                // 忽略格式错误
            }
        }
        
        List<Major> majors = majorService.searchMajors(keyword, facultyId);
        Map<String, Object> statistics = majorService.getMajorStatistics();
        List<Map<String, Object>> facultyDistribution = majorService.getFacultyMajorDistribution();
        List<Map<String, Object>> faculties = majorService.getAllFaculties();
        
        request.setAttribute("majors", majors);
        request.setAttribute("statistics", statistics);
        request.setAttribute("facultyDistribution", facultyDistribution);
        request.setAttribute("faculties", faculties);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("selectedFacultyId", facultyId);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/major/list.jsp").forward(request, response);
    }
    
    /**
     * 从请求中创建专业对象（用于表单数据回显）
     */
    private Major createMajorFromRequest(HttpServletRequest request) {
        Major major = new Major();
        major.setHylMname10(request.getParameter("hylMname10"));
        major.setHylMdegree10(request.getParameter("hylMdegree10"));
        
        try {
            String yearsStr = request.getParameter("hylMyears10");
            if (yearsStr != null && !yearsStr.trim().isEmpty()) {
                major.setHylMyears10(Integer.parseInt(yearsStr));
            }
        } catch (NumberFormatException e) {
            // 忽略格式错误
        }
        
        try {
            String facultyIdStr = request.getParameter("hylFno10");
            if (facultyIdStr != null && !facultyIdStr.trim().isEmpty()) {
                major.setHylFno10(Integer.parseInt(facultyIdStr));
            }
        } catch (NumberFormatException e) {
            // 忽略格式错误
        }
        
        return major;
    }
} 