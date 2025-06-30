package org.example.demo111.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.demo111.model.Enrollment;
import org.example.demo111.model.Course;
import org.example.demo111.model.User;
import org.example.demo111.service.EnrollmentService;
import org.example.demo111.service.CourseService;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * 成绩录入控制器
 */
@WebServlet("/score-entry/*")
public class ScoreEntryController extends HttpServlet {
    private final EnrollmentService enrollmentService;
    private final CourseService courseService;
    
    public ScoreEntryController() {
        this.enrollmentService = new EnrollmentService();
        this.courseService = new CourseService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || "/".equals(pathInfo)) {
                showTeachingClassList(request, response);
            } else if ("/class".equals(pathInfo)) {
                showClassScoreEntry(request, response);
            } else if ("/batch".equals(pathInfo)) {
                showBatchScoreEntry(request, response);
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
            if ("/update-score".equals(pathInfo)) {
                updateSingleScore(request, response);
            } else if ("/batch-update".equals(pathInfo)) {
                batchUpdateScores(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示教学班列表（供选择录入成绩的班级）
     */
    private void showTeachingClassList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        List<Map<String, Object>> teachingClasses;
        
        try {
            if ("admin".equals(currentUser.getUserType())) {
                // 管理员可以看到所有教学班
                teachingClasses = courseService.getAllTeachingClassesForScoreEntry();
            } else if ("teacher".equals(currentUser.getUserType())) {
                // 教师只能看到自己的教学班
                Integer teacherId = currentUser.getUserId();
                teachingClasses = courseService.findTeachingClassesByTeacherId(teacherId);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足");
                return;
            }
            
            request.setAttribute("teachingClasses", teachingClasses);
            request.setAttribute("userType", currentUser.getUserType());
            request.getRequestDispatcher("/WEB-INF/views/score-entry/class-list.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("获取教学班列表失败", e);
        }
    }
    
    /**
     * 显示班级成绩录入页面
     */
    private void showClassScoreEntry(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String teachingClassIdStr = request.getParameter("teachingClassId");
        if (teachingClassIdStr == null || teachingClassIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "教学班编号不能为空");
            return;
        }
        
        try {
            Integer teachingClassId = Integer.parseInt(teachingClassIdStr);
            
            // 权限检查
            if ("teacher".equals(currentUser.getUserType())) {
                // 检查教师是否有权限访问该教学班
                if (!hasTeacherPermission(currentUser.getUserId(), teachingClassId)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "您没有权限访问该教学班");
                    return;
                }
            }
            
            // 获取教学班的课程信息
            Course course = courseService.findByTeachingClassId(teachingClassId);
            if (course == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "教学班不存在");
                return;
            }
            
            // 获取该教学班的学生列表
            List<Enrollment> enrollments = enrollmentService.findEnrollmentsByTeachingClassId(teachingClassId);
            
            request.setAttribute("course", course);
            request.setAttribute("teachingClassId", teachingClassId);
            request.setAttribute("enrollments", enrollments);
            request.setAttribute("userType", currentUser.getUserType());
            
            request.getRequestDispatcher("/WEB-INF/views/score-entry/score-entry.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "教学班编号格式错误");
        } catch (Exception e) {
            throw new ServletException("获取班级成绩录入页面失败", e);
        }
    }
    
    /**
     * 显示批量成绩录入页面
     */
    private void showBatchScoreEntry(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String teachingClassIdStr = request.getParameter("teachingClassId");
        if (teachingClassIdStr == null || teachingClassIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "教学班编号不能为空");
            return;
        }
        
        try {
            Integer teachingClassId = Integer.parseInt(teachingClassIdStr);
            
            // 权限检查
            if ("teacher".equals(currentUser.getUserType())) {
                if (!hasTeacherPermission(currentUser.getUserId(), teachingClassId)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "您没有权限访问该教学班");
                    return;
                }
            }
            
            // 获取教学班的课程信息
            Course course = courseService.findByTeachingClassId(teachingClassId);
            if (course == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "教学班不存在");
                return;
            }
            
            // 获取该教学班的学生列表
            List<Enrollment> enrollments = enrollmentService.findEnrollmentsByTeachingClassId(teachingClassId);
            
            request.setAttribute("course", course);
            request.setAttribute("teachingClassId", teachingClassId);
            request.setAttribute("enrollments", enrollments);
            request.setAttribute("userType", currentUser.getUserType());
            
            request.getRequestDispatcher("/WEB-INF/views/score-entry/batch-entry.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "教学班编号格式错误");
        } catch (Exception e) {
            throw new ServletException("获取批量成绩录入页面失败", e);
        }
    }
    
    /**
     * 更新单个学生成绩
     */
    private void updateSingleScore(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String studentIdStr = request.getParameter("studentId");
        String teachingClassIdStr = request.getParameter("teachingClassId");
        String scoreStr = request.getParameter("score");
        
        if (studentIdStr == null || teachingClassIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "学号和教学班编号不能为空");
            return;
        }
        
        try {
            Integer studentId = Integer.parseInt(studentIdStr);
            Integer teachingClassId = Integer.parseInt(teachingClassIdStr);
            Integer score = null;
            
            if (scoreStr != null && !scoreStr.trim().isEmpty()) {
                score = Integer.parseInt(scoreStr);
                if (score < 0 || score > 100) {
                    request.setAttribute("error", "成绩必须在0-100之间");
                    showClassScoreEntry(request, response);
                    return;
                }
            }
            
            // 权限检查
            if ("teacher".equals(currentUser.getUserType())) {
                if (!hasTeacherPermission(currentUser.getUserId(), teachingClassId)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "您没有权限修改该教学班的成绩");
                    return;
                }
            }
            
            // 更新成绩
            boolean success = enrollmentService.updateScoreAndGPA(studentId, teachingClassId, score);
            
            if (success) {
                request.setAttribute("success", "成绩更新成功");
            } else {
                request.setAttribute("error", "成绩更新失败");
            }
            
            // 重新显示成绩录入页面
            showClassScoreEntry(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "数据格式错误");
            showClassScoreEntry(request, response);
        } catch (Exception e) {
            throw new ServletException("更新成绩失败", e);
        }
    }
    
    /**
     * 批量更新成绩
     */
    private void batchUpdateScores(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String teachingClassIdStr = request.getParameter("teachingClassId");
        if (teachingClassIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "教学班编号不能为空");
            return;
        }
        
        try {
            Integer teachingClassId = Integer.parseInt(teachingClassIdStr);
            
            // 权限检查
            if ("teacher".equals(currentUser.getUserType())) {
                if (!hasTeacherPermission(currentUser.getUserId(), teachingClassId)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "您没有权限修改该教学班的成绩");
                    return;
                }
            }
            
            // 获取所有学生的成绩参数
            Map<String, String[]> parameterMap = request.getParameterMap();
            int successCount = 0;
            int errorCount = 0;
            StringBuilder errorMessage = new StringBuilder();
            
            for (String paramName : parameterMap.keySet()) {
                if (paramName.startsWith("score_")) {
                    String studentIdStr = paramName.substring(6); // 去掉"score_"前缀
                    String scoreStr = request.getParameter(paramName);
                    
                    try {
                        Integer studentId = Integer.parseInt(studentIdStr);
                        Integer score = null;
                        
                        if (scoreStr != null && !scoreStr.trim().isEmpty()) {
                            score = Integer.parseInt(scoreStr);
                            if (score < 0 || score > 100) {
                                errorMessage.append("学号 ").append(studentId).append(" 的成绩必须在0-100之间；");
                                errorCount++;
                                continue;
                            }
                        }
                        
                        boolean success = enrollmentService.updateScoreAndGPA(studentId, teachingClassId, score);
                        if (success) {
                            successCount++;
                        } else {
                            errorMessage.append("学号 ").append(studentId).append(" 成绩更新失败；");
                            errorCount++;
                        }
                        
                    } catch (NumberFormatException e) {
                        errorMessage.append("学号 ").append(studentIdStr).append(" 或成绩格式错误；");
                        errorCount++;
                    }
                }
            }
            
            // 设置结果消息
            if (successCount > 0) {
                request.setAttribute("success", "成功更新 " + successCount + " 个学生的成绩");
            }
            if (errorCount > 0) {
                request.setAttribute("error", "有 " + errorCount + " 个错误：" + errorMessage.toString());
            }
            
            // 重新显示批量录入页面
            showBatchScoreEntry(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "教学班编号格式错误");
            showBatchScoreEntry(request, response);
        } catch (Exception e) {
            throw new ServletException("批量更新成绩失败", e);
        }
    }
    
    /**
     * 检查教师是否有权限访问指定教学班
     */
    private boolean hasTeacherPermission(Integer teacherId, Integer teachingClassId) {
        try {
            List<Map<String, Object>> teachingClasses = courseService.findTeachingClassesByTeacherId(teacherId);
            return teachingClasses.stream()
                    .anyMatch(tc -> teachingClassId.equals(tc.get("hyl_tcno10")));
        } catch (Exception e) {
            return false;
        }
    }
} 