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
 * 成绩统计控制器
 */
@WebServlet("/score/*")
public class ScoreController extends HttpServlet {
    private final StudentService studentService;
    
    public ScoreController() {
        this.studentService = new StudentService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || "/".equals(pathInfo) || "/stats".equals(pathInfo)) {
                showScoreStats(request, response);
            } else if ("/ranking".equals(pathInfo)) {
                showScoreRanking(request, response);
            } else if ("/analysis".equals(pathInfo)) {
                showScoreAnalysis(request, response);
            } else if ("/distribution".equals(pathInfo)) {
                showScoreDistribution(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示成绩统计概览
     */
    private void showScoreStats(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // 获取总体统计信息
            Map<String, Object> overallStats = studentService.getOverallScoreStats();
            
            // 获取各专业统计信息
            List<Map<String, Object>> majorStats = studentService.getScoreStatsByMajor();
            
            // 获取成绩分布
            Map<String, Object> scoreDistribution = studentService.getScoreDistribution();
            
            request.setAttribute("overallStats", overallStats);
            request.setAttribute("majorStats", majorStats);
            request.setAttribute("scoreDistribution", scoreDistribution);
            
            request.getRequestDispatcher("/WEB-INF/views/score/stats.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "获取成绩统计信息失败: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示成绩排名
     */
    private void showScoreRanking(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String major = request.getParameter("major");
            String limit = request.getParameter("limit");
            
            List<Map<String, Object>> rankings;
            if (major != null && !major.trim().isEmpty()) {
                rankings = studentService.getScoreRankingByMajor(major);
            } else {
                rankings = studentService.getAllStudentsRanking();
            }
            
            // 如果指定了限制数量
            if (limit != null && !limit.trim().isEmpty()) {
                int limitNum = Integer.parseInt(limit);
                if (rankings.size() > limitNum) {
                    rankings = rankings.subList(0, limitNum);
                }
            }
            
            request.setAttribute("rankings", rankings);
            request.setAttribute("selectedMajor", major);
            request.setAttribute("limit", limit);
            
            request.getRequestDispatcher("/WEB-INF/views/score/ranking.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "获取成绩排名失败: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示成绩分析
     */
    private void showScoreAnalysis(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String major = request.getParameter("major");
            
            Map<String, Object> analysis;
            if (major != null && !major.trim().isEmpty()) {
                analysis = studentService.getScoreAnalysisByMajor(major);
            } else {
                analysis = studentService.getOverallScoreAnalysis();
            }
            
            request.setAttribute("analysis", analysis);
            request.setAttribute("selectedMajor", major);
            
            request.getRequestDispatcher("/WEB-INF/views/score/analysis.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "获取成绩分析失败: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示成绩分布
     */
    private void showScoreDistribution(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String major = request.getParameter("major");
            
            Map<String, Object> distribution;
            if (major != null && !major.trim().isEmpty()) {
                distribution = studentService.getScoreDistributionByMajor(major);
            } else {
                distribution = studentService.getScoreDistribution();
            }
            
            request.setAttribute("distribution", distribution);
            request.setAttribute("selectedMajor", major);
            
            request.getRequestDispatcher("/WEB-INF/views/score/distribution.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "获取成绩分布失败: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
} 