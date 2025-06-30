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
 * 学生成绩分析控制器
 */
@WebServlet("/student-score-analysis/*")
public class StudentScoreAnalysisController extends HttpServlet {
    private final StudentService studentService;
    
    public StudentScoreAnalysisController() {
        this.studentService = new StudentService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || "/".equals(pathInfo) || "/overall".equals(pathInfo)) {
                showOverallScoreAnalysis(request, response);
            } else if ("/by-major".equals(pathInfo)) {
                showScoreAnalysisByMajor(request, response);
            } else if ("/distribution".equals(pathInfo)) {
                showScoreDistribution(request, response);
            } else if ("/major-ranking".equals(pathInfo)) {
                showMajorRanking(request, response);
            } else if ("/major-stats".equals(pathInfo)) {
                showMajorStats(request, response);
            } else if ("/major-distribution".equals(pathInfo)) {
                showMajorDistribution(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示总体成绩分析
     */
    private void showOverallScoreAnalysis(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Map<String, Object> overallStats = studentService.getOverallScoreStats();
        Map<String, Object> overallAnalysis = studentService.getOverallScoreAnalysis();
        
        request.setAttribute("overallStats", overallStats);
        request.setAttribute("overallAnalysis", overallAnalysis);
        request.getRequestDispatcher("/WEB-INF/views/student/score-analysis.jsp").forward(request, response);
    }
    
    /**
     * 显示专业成绩分析
     */
    private void showScoreAnalysisByMajor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String major = request.getParameter("major");
        
        if (major != null && !major.trim().isEmpty()) {
            // 显示特定专业的分析
            Map<String, Object> majorAnalysis = studentService.getScoreAnalysisByMajor(major);
            Map<String, Object> majorDistribution = studentService.getScoreDistributionByMajor(major);
            
            request.setAttribute("majorAnalysis", majorAnalysis);
            request.setAttribute("majorDistribution", majorDistribution);
            request.setAttribute("selectedMajor", major);
        }
        
        // 获取所有专业统计
        List<Map<String, Object>> majorStats = studentService.getScoreStatsByMajor();
        request.setAttribute("majorStats", majorStats);
        
        request.getRequestDispatcher("/WEB-INF/views/student/major-score-analysis.jsp").forward(request, response);
    }
    
    /**
     * 显示成绩分布
     */
    private void showScoreDistribution(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Map<String, Object> distribution = studentService.getScoreDistribution();
        request.setAttribute("distribution", distribution);
        request.getRequestDispatcher("/WEB-INF/views/student/score-distribution.jsp").forward(request, response);
    }
    
    /**
     * 显示专业排名
     */
    private void showMajorRanking(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String major = request.getParameter("major");
        
        if (major != null && !major.trim().isEmpty()) {
            List<Map<String, Object>> rankings = studentService.getScoreRankingByMajor(major);
            request.setAttribute("rankings", rankings);
            request.setAttribute("selectedMajor", major);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/student/major-ranking.jsp").forward(request, response);
    }
    
    /**
     * 显示专业统计
     */
    private void showMajorStats(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Map<String, Object>> majorStats = studentService.getScoreStatsByMajor();
        request.setAttribute("majorStats", majorStats);
        request.getRequestDispatcher("/WEB-INF/views/student/major-stats.jsp").forward(request, response);
    }
    
    /**
     * 显示专业成绩分布
     */
    private void showMajorDistribution(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String major = request.getParameter("major");
        
        if (major != null && !major.trim().isEmpty()) {
            Map<String, Object> distribution = studentService.getScoreDistributionByMajor(major);
            request.setAttribute("distribution", distribution);
            request.setAttribute("selectedMajor", major);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/student/major-distribution.jsp").forward(request, response);
    }
} 