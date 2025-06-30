package org.example.demo111.controller;

import java.io.IOException;
import java.util.List;

import org.example.demo111.model.AClass;
import org.example.demo111.model.Major;
import org.example.demo111.service.AClassService;
import org.example.demo111.service.MajorService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 行政班管理控制器
 */
@WebServlet("/admin/aclass/*")
public class AClassController extends HttpServlet {
    private final AClassService aClassService;
    private final MajorService majorService;
    
    public AClassController() {
        this.aClassService = new AClassService();
        this.majorService = new MajorService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || "/".equals(pathInfo) || "/list".equals(pathInfo)) {
                listAClasses(request, response);
            } else if ("/add".equals(pathInfo)) {
                showAddAClassForm(request, response);
            } else if ("/view".equals(pathInfo)) {
                viewAClass(request, response);
            } else if ("/edit".equals(pathInfo)) {
                editAClass(request, response);
            } else if ("/search".equals(pathInfo)) {
                searchAClasses(request, response);
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
                addAClass(request, response);
            } else if ("/update".equals(pathInfo)) {
                updateAClass(request, response);
            } else if ("/delete".equals(pathInfo)) {
                deleteAClass(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 列出所有行政班
     */
    private void listAClasses(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<AClass> aClasses = aClassService.getAllAClasses();
        request.setAttribute("aClasses", aClasses);
        request.getRequestDispatcher("/WEB-INF/views/admin/aclass/list.jsp").forward(request, response);
    }
    
    /**
     * 显示添加行政班表单
     */
    private void showAddAClassForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // 获取所有专业列表
            List<Major> majors = majorService.getAllMajors();
            request.setAttribute("majors", majors);
            request.getRequestDispatcher("/WEB-INF/views/admin/aclass/add.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "获取专业列表失败: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 查看行政班详情
     */
    private void viewAClass(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Integer aClassId = Integer.parseInt(request.getParameter("id"));
        AClass aClass = aClassService.getAClassById(aClassId);
        
        if (aClass == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "行政班不存在");
            return;
        }
        
        request.setAttribute("aClass", aClass);
        request.getRequestDispatcher("/WEB-INF/views/admin/aclass/view.jsp").forward(request, response);
    }
    
    /**
     * 编辑行政班信息
     */
    private void editAClass(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            Integer aClassId = Integer.parseInt(request.getParameter("id"));
            AClass aClass = aClassService.getAClassById(aClassId);
            
            if (aClass == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "行政班不存在");
                return;
            }
            
            // 获取所有专业列表
            List<Major> majors = majorService.getAllMajors();
            
            request.setAttribute("aClass", aClass);
            request.setAttribute("majors", majors);
            request.getRequestDispatcher("/WEB-INF/views/admin/aclass/edit.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "获取行政班信息或专业列表失败: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 搜索行政班
     */
    private void searchAClasses(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        
        List<AClass> aClasses = aClassService.searchAClasses(keyword);
        
        request.setAttribute("aClasses", aClasses);
        request.setAttribute("searchKeyword", keyword);
        request.getRequestDispatcher("/WEB-INF/views/admin/aclass/list.jsp").forward(request, response);
    }
    
    /**
     * 添加行政班
     */
    private void addAClass(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            AClass aClass = parseAClassFromRequest(request);
            
            boolean success = aClassService.addAClass(aClass);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "行政班 " + aClass.getHylAcname10() + " 添加成功！");
                response.sendRedirect(request.getContextPath() + "/admin/aclass/list");
                return;
            } else {
                request.setAttribute("error", "添加行政班失败，请重试");
                
                // 重新获取专业列表
                List<Major> majors = majorService.getAllMajors();
                request.setAttribute("majors", majors);
                request.setAttribute("aClass", aClass);
                
                request.getRequestDispatcher("/WEB-INF/views/admin/aclass/add.jsp").forward(request, response);
                return;
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "添加行政班时发生错误: " + e.getMessage());
            
            // 重新获取专业列表
            try {
                List<Major> majors = majorService.getAllMajors();
                request.setAttribute("majors", majors);
            } catch (Exception ex) {
                System.err.println("获取专业列表失败: " + ex.getMessage());
            }
            
            request.getRequestDispatcher("/WEB-INF/views/admin/aclass/add.jsp").forward(request, response);
        }
    }
    
    /**
     * 更新行政班信息
     */
    private void updateAClass(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            AClass aClass = parseAClassFromRequest(request);
            
            boolean success = aClassService.updateAClass(aClass);
            if (success) {
                request.getSession().setAttribute("successMessage", "行政班 " + aClass.getHylAcname10() + " 更新成功！");
                response.sendRedirect(request.getContextPath() + "/admin/aclass/view?id=" + aClass.getHylAcno10());
            } else {
                request.setAttribute("error", "更新行政班信息失败");
                request.setAttribute("aClass", aClass);
                
                // 重新获取专业列表
                List<Major> majors = majorService.getAllMajors();
                request.setAttribute("majors", majors);
                
                request.getRequestDispatcher("/WEB-INF/views/admin/aclass/edit.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "更新行政班时发生错误: " + e.getMessage());
            
            // 重新获取专业列表
            try {
                List<Major> majors = majorService.getAllMajors();
                request.setAttribute("majors", majors);
            } catch (Exception ex) {
                System.err.println("获取专业列表失败: " + ex.getMessage());
            }
            
            request.getRequestDispatcher("/WEB-INF/views/admin/aclass/edit.jsp").forward(request, response);
        }
    }
    
    /**
     * 删除行政班
     */
    private void deleteAClass(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            Integer aClassId = Integer.parseInt(request.getParameter("id"));
            boolean success = aClassService.deleteAClass(aClassId);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "行政班删除成功！");
                response.sendRedirect(request.getContextPath() + "/admin/aclass/list");
            } else {
                request.setAttribute("error", "删除行政班失败");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "删除行政班时发生错误: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 从请求参数解析行政班对象
     */
    private AClass parseAClassFromRequest(HttpServletRequest request) {
        AClass aClass = new AClass();
        
        String aClassIdStr = request.getParameter("hylAcno10");
        if (aClassIdStr != null && !aClassIdStr.trim().isEmpty()) {
            aClass.setHylAcno10(Integer.parseInt(aClassIdStr));
        }
        
        aClass.setHylAcname10(request.getParameter("hylAcname10"));
        
        String yearStr = request.getParameter("hylAcyear10");
        if (yearStr != null && !yearStr.trim().isEmpty()) {
            aClass.setHylAcyear10(Integer.parseInt(yearStr));
        }
        
        String maxStuStr = request.getParameter("hylAcmaxstu10");
        if (maxStuStr != null && !maxStuStr.trim().isEmpty()) {
            aClass.setHylAcmaxstu10(Integer.parseInt(maxStuStr));
        }
        
        String majorIdStr = request.getParameter("hylMno10");
        if (majorIdStr != null && !majorIdStr.trim().isEmpty()) {
            aClass.setHylMno10(Integer.parseInt(majorIdStr));
        }
        
        return aClass;
    }
} 