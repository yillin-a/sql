package org.example.demo111.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.demo111.service.StudentService;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * 学生生源地分析控制器
 */
@WebServlet("/student-origin-analysis/*")
public class StudentOriginAnalysisController extends HttpServlet {
    private final StudentService studentService;
    
    public StudentOriginAnalysisController() {
        this.studentService = new StudentService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || "/".equals(pathInfo) || "/overall".equals(pathInfo)) {
                showOriginOverallAnalysis(request, response);
            } else if ("/distribution".equals(pathInfo)) {
                showOriginDistribution(request, response);
            } else if ("/ranking".equals(pathInfo)) {
                showOriginRanking(request, response);
            } else if ("/analysis".equals(pathInfo)) {
                showOriginAnalysis(request, response);
            } else if ("/performance".equals(pathInfo)) {
                showOriginPerformance(request, response);
            } else if ("/top-origins".equals(pathInfo)) {
                showTopOrigins(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示生源地总体分析
     */
    private void showOriginOverallAnalysis(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Map<String, Object> overallStats = studentService.getOriginOverallStats();
        request.setAttribute("overallStats", overallStats);
        request.getRequestDispatcher("/WEB-INF/views/student/origin-overall-analysis.jsp").forward(request, response);
    }
    
    /**
     * 显示生源地分布
     */
    private void showOriginDistribution(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Map<String, Object> distribution = studentService.getOriginDistribution();
        List<Map<String, Object>> distributionList = studentService.getOriginDistributionList();
        
        request.setAttribute("distribution", distribution);
        request.setAttribute("distributionList", distributionList);
        request.getRequestDispatcher("/WEB-INF/views/student/origin-distribution.jsp").forward(request, response);
    }
    
    /**
     * 显示生源地排名
     */
    private void showOriginRanking(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Map<String, Object>> rankings = studentService.getOriginRanking();
        request.setAttribute("rankings", rankings);
        request.getRequestDispatcher("/WEB-INF/views/student/origin-ranking.jsp").forward(request, response);
    }
    
    /**
     * 显示生源地分析
     */
    private void showOriginAnalysis(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Map<String, Object> analysis = studentService.getOriginAnalysis();
        request.setAttribute("analysis", analysis);
        request.getRequestDispatcher("/WEB-INF/views/student/origin-analysis.jsp").forward(request, response);
    }
    
    /**
     * 显示生源地表现
     */
    private void showOriginPerformance(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Map<String, Object>> performance = studentService.getOriginPerformance();
        request.setAttribute("performance", performance);
        request.getRequestDispatcher("/WEB-INF/views/student/origin-performance.jsp").forward(request, response);
    }
    
    /**
     * 显示顶级生源地
     */
    private void showTopOrigins(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String limitStr = request.getParameter("limit");
        int limit = 10; // 默认显示前10名
        
        if (limitStr != null && !limitStr.trim().isEmpty()) {
            try {
                limit = Integer.parseInt(limitStr);
            } catch (NumberFormatException e) {
                // 使用默认值
            }
        }
        
        List<Map<String, Object>> topOrigins = studentService.getTopOrigins(limit);
        request.setAttribute("topOrigins", topOrigins);
        request.setAttribute("limit", limit);
        request.getRequestDispatcher("/WEB-INF/views/student/top-origins.jsp").forward(request, response);
    }
} 