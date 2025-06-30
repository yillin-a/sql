package org.example.demo111.controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.example.demo111.dao.FacultyDAO;
import org.example.demo111.model.Teacher;
import org.example.demo111.model.User;
import org.example.demo111.service.CourseService;
import org.example.demo111.service.TeacherService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 教师管理控制器
 */
@WebServlet("/teacher/*")
public class TeacherController extends HttpServlet {
    private final TeacherService teacherService;
    private final FacultyDAO facultyDAO;
    private final SimpleDateFormat dateFormat;
    private final CourseService courseService;
    
    public TeacherController() {
        this.teacherService = new TeacherService();
        this.facultyDAO = new FacultyDAO();
        this.dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        this.courseService = new CourseService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || "/".equals(pathInfo) || "/list".equals(pathInfo)) {
                listTeachers(request, response);
            } else if ("/add".equals(pathInfo)) {
                showAddTeacherForm(request, response);
            } else if ("/view".equals(pathInfo)) {
                viewTeacher(request, response);
            } else if ("/edit".equals(pathInfo)) {
                editTeacher(request, response);
            } else if ("/search".equals(pathInfo)) {
                searchTeachers(request, response);
            } else if ("/title".equals(pathInfo)) {
                getTeachersByTitle(request, response);
            } else if ("/active".equals(pathInfo)) {
                listActiveTeachers(request, response);
            } else if ("/profile".equals(pathInfo)) {
                showEditProfileForm(request, response);
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
                addTeacher(request, response);
            } else if ("/update".equals(pathInfo)) {
                updateTeacher(request, response);
            } else if ("/profile".equals(pathInfo)) {
                updateTeacherProfile(request, response);
            } else if ("/delete".equals(pathInfo)) {
                deleteTeacher(request, response);
            } else if ("/status".equals(pathInfo)) {
                updateTeacherStatus(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 列出所有教师
     */
    private void listTeachers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，无法访问教师列表");
            return;
        }
        
        List<Teacher> teachers = teacherService.getAllTeachers();
        request.setAttribute("teachers", teachers);
        request.getRequestDispatcher("/WEB-INF/views/teacher/list.jsp").forward(request, response);
    }
    
    /**
     * 显示添加教师表单
     */
    private void showAddTeacherForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，无法添加教师");
            return;
        }
        
        try {
            List<Map<String, Object>> faculties = facultyDAO.getAllFaculties();
            request.setAttribute("faculties", faculties);
        } catch (Exception e) {
            // 如果获取学院列表失败，设置为空列表
            request.setAttribute("faculties", new ArrayList<>());
        }
        request.getRequestDispatcher("/WEB-INF/views/teacher/add.jsp").forward(request, response);
    }
    
    /**
     * 查看教师详情
     */
    private void viewTeacher(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，无法查看教师详情");
            return;
        }
        
        Integer teacherId = Integer.parseInt(request.getParameter("id"));
        Teacher teacher = teacherService.getTeacherById(teacherId);
        
        if (teacher == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "教师不存在");
            return;
        }
        
        request.setAttribute("teacher", teacher);
        request.getRequestDispatcher("/WEB-INF/views/teacher/view.jsp").forward(request, response);
    }
    
    /**
     * 编辑教师信息
     */
    private void editTeacher(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，无法编辑教师信息");
            return;
        }
        
        Integer teacherId = Integer.parseInt(request.getParameter("id"));
        Teacher teacher = teacherService.getTeacherById(teacherId);
        
        if (teacher == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "教师不存在");
            return;
        }
        
        request.setAttribute("teacher", teacher);
        request.getRequestDispatcher("/WEB-INF/views/teacher/edit.jsp").forward(request, response);
    }
    
    /**
     * 搜索教师
     */
    private void searchTeachers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，无法搜索教师");
            return;
        }
        
        String name = request.getParameter("name");
        List<Teacher> teachers = teacherService.searchTeachersByName(name);
        request.setAttribute("teachers", teachers);
        request.setAttribute("searchName", name);
        request.getRequestDispatcher("/WEB-INF/views/teacher/list.jsp").forward(request, response);
    }
    
    /**
     * 根据职称查询教师
     */
    private void getTeachersByTitle(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，无法按职称查询教师");
            return;
        }
        
        String title = request.getParameter("title");
        List<Teacher> teachers = teacherService.getTeachersByTitle(title);
        request.setAttribute("teachers", teachers);
        request.setAttribute("searchTitle", title);
        request.getRequestDispatcher("/WEB-INF/views/teacher/list.jsp").forward(request, response);
    }
    
    /**
     * 列出在职教师
     */
    private void listActiveTeachers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，无法查看在职教师列表");
            return;
        }
        
        List<Teacher> teachers = teacherService.getActiveTeachers();
        request.setAttribute("teachers", teachers);
        request.setAttribute("filterActive", true);
        request.getRequestDispatcher("/WEB-INF/views/teacher/list.jsp").forward(request, response);
    }
    
    /**
     * 显示教师个人信息编辑表单
     */
    private void showEditProfileForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"teacher".equals(currentUser.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        System.out.println("currentUser: " + currentUser.getUserId());

        try {
            Integer teacherId = currentUser.getUserId();
            Teacher teacher = teacherService.getTeacherById(teacherId);
            
            if (teacher == null) {
                request.setAttribute("error", "无法找到您的教师信息");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("teacher", teacher);

            System.out.println("teacher: " + teacher);

            request.getRequestDispatcher("/WEB-INF/views/teacher/profile-edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "您的用户ID格式不正确，无法加载个人信息");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 更新教师个人资料
     */
    private void updateTeacherProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 检查用户登录状态和权限
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"teacher".equals(currentUser.getUserType())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // 获取表单参数
            String email = request.getParameter("hylTemail10");
            String phone = request.getParameter("hylTphone10");
            
            // 验证邮箱格式（如果填写）
            if (email != null && !email.trim().isEmpty() && !email.contains("@")) {
                request.setAttribute("error", "邮箱格式不正确");
                showEditProfileForm(request, response);
                return;
            }
            
            // 更新教师信息
            Integer teacherId = currentUser.getUserId();
            boolean success = teacherService.updateTeacherProfile(teacherId, 
                    email != null ? email.trim() : null, 
                    phone != null ? phone.trim() : null);
            
            if (success) {
                request.setAttribute("success", "个人信息更新成功！");
            } else {
                request.setAttribute("error", "信息更新失败，请重试");
            }
            
            // 重新显示编辑页面
            showEditProfileForm(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "用户ID格式错误");
            showEditProfileForm(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "更新个人信息失败：" + e.getMessage());
            showEditProfileForm(request, response);
        }
    }
    
    /**
     * 添加教师
     */
    private void addTeacher(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，无法添加教师");
            return;
        }
        
        try {
            Teacher teacher = parseTeacherFromRequest(request);
            
            if (!teacherService.validateTeacher(teacher)) {
                request.setAttribute("error", "教师信息验证失败，请检查输入数据");
                request.getRequestDispatcher("/WEB-INF/views/teacher/add.jsp").forward(request, response);
                return;
            }
            
            boolean success = teacherService.addTeacher(teacher);
            
            if (success) {
                // 添加成功提示，包含触发器信息
                String message = String.format("教师 %s 添加成功！工号：%d\n" +
                    "系统已自动为该教师创建登录账户：\n" +
                    "用户名：%d\n" +
                    "默认密码为教师工号: %d\n" +
                    "请通知教师及时修改密码。", 
                    teacher.getHylTname10(), 
                    teacher.getHylTno10(),
                    teacher.getHylTno10(),
                    teacher.getHylTno10());
                
                request.setAttribute("message", message);
                request.setAttribute("newTeacher", teacher);
            } else {
                request.setAttribute("error", "添加教师失败，请重试");
            }
            
            // 重新加载教师列表
            listTeachers(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "添加教师时发生错误: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/teacher/add.jsp").forward(request, response);
        }
    }
    
    /**
     * 更新教师信息
     */
    private void updateTeacher(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，无法更新教师信息");
            return;
        }
        
        Teacher teacher = parseTeacherFromRequest(request);
        
        if (!teacherService.validateTeacher(teacher)) {
            request.setAttribute("error", "教师信息验证失败");
            request.setAttribute("teacher", teacher);
            request.getRequestDispatcher("/WEB-INF/views/teacher/edit.jsp").forward(request, response);
            return;
        }
        
        boolean success = teacherService.updateTeacher(teacher);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/teacher/view?id=" + teacher.getHylTno10());
        } else {
            request.setAttribute("error", "更新教师信息失败");
            request.setAttribute("teacher", teacher);
            request.getRequestDispatcher("/WEB-INF/views/teacher/edit.jsp").forward(request, response);
        }
    }
    
    /**
     * 删除教师
     */
    private void deleteTeacher(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，无法删除教师");
            return;
        }
        
        Integer teacherId = Integer.parseInt(request.getParameter("id"));
        
        boolean success = teacherService.deleteTeacher(teacherId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/teacher/list");
        } else {
            request.setAttribute("error", "删除教师失败");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 更新教师状态
     */
    private void updateTeacherStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足，无法更新教师状态");
            return;
        }
        
        Integer teacherId = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        
        if (!teacherService.validateStatus(status)) {
            request.setAttribute("error", "无效的状态");
            listTeachers(request, response);
            return;
        }
        
        boolean success = teacherService.updateTeacherStatus(teacherId, status);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/teacher/view?id=" + teacherId);
        } else {
            request.setAttribute("error", "更新教师状态失败");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 从请求参数解析教师对象
     */
    private Teacher parseTeacherFromRequest(HttpServletRequest request) {
        Teacher teacher = new Teacher();
        // The id from the form for update operations
        String idStr = request.getParameter("id");
        if(idStr != null && !idStr.isEmpty()){
            teacher.setHylTno10(Integer.parseInt(idStr));
        }

        teacher.setHylTname10(request.getParameter("hylTname10"));

        teacher.setHylTsex10(request.getParameter("hylTsex10"));
        teacher.setHylTtitle10(request.getParameter("hylTtitle10"));
        teacher.setHylTemail10(request.getParameter("hylTemail10"));
        
        String birthDateStr = request.getParameter("hylTbirth10");
        if (birthDateStr != null && !birthDateStr.isEmpty()) {
            try {
                java.util.Date utilDate = dateFormat.parse(birthDateStr);
                teacher.setHylTbirth10(new java.sql.Date(utilDate.getTime()));
                // 根据出生日期自动计算年龄
                teacher.setHylTage10(calculateAge(utilDate));
            } catch (ParseException e) {
                // handle parsing error, maybe log it or set a default
                teacher.setHylTbirth10(null);
            }
        }
        
        if (request.getParameter("hylFno10") != null && !request.getParameter("hylFno10").isEmpty()) {
            teacher.setHylFno10(Integer.parseInt(request.getParameter("hylFno10")));
        }
        teacher.setHylTstatus10(request.getParameter("hylTstatus10"));
        
        return teacher;
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