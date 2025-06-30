package org.example.demo111.controller;

import org.example.demo111.dao.StudentDAO;
import org.example.demo111.service.StudentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * 生源地统计控制器
 */
@WebServlet("/origin/*")
public class OriginController extends HttpServlet {
    private final StudentService studentService;
    
    public OriginController() {
        this.studentService = new StudentService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || "/".equals(pathInfo) || "/stats".equals(pathInfo)) {
                showOriginStats(request, response);
            } else if ("/distribution".equals(pathInfo)) {
                showOriginDistribution(request, response);
            } else if ("/ranking".equals(pathInfo)) {
                showOriginRanking(request, response);
            } else if ("/analysis".equals(pathInfo)) {
                showOriginAnalysis(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示生源地统计概览
     */
    private void showOriginStats(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            Map<String, Object> overallStats = studentService.getOriginOverallStats();
            List<Map<String, Object>> topOrigins = studentService.getTopOrigins(10);
            Map<String, Object> distribution = studentService.getOriginDistribution();
            
            request.setAttribute("overallStats", overallStats);
            request.setAttribute("topOrigins", topOrigins);
            request.setAttribute("distribution", distribution);
            
            request.getRequestDispatcher("/WEB-INF/views/origin/stats.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "获取生源地统计失败: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示生源地分布
     */
    private void showOriginDistribution(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Map<String, Object>> distribution = studentService.getOriginDistributionList();
            request.setAttribute("distribution", distribution);
            request.getRequestDispatcher("/WEB-INF/views/origin/distribution.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "获取生源地分布失败: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示生源地排名
     */
    private void showOriginRanking(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Map<String, Object>> ranking = studentService.getOriginRanking();
            request.setAttribute("ranking", ranking);
            request.getRequestDispatcher("/WEB-INF/views/origin/ranking.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "获取生源地排名失败: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 显示生源地分析
     */
    private void showOriginAnalysis(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            Map<String, Object> analysis = studentService.getOriginAnalysis();
            List<Map<String, Object>> originPerformance = studentService.getOriginPerformance();
            request.setAttribute("analysis", analysis);
            request.setAttribute("originPerformance", originPerformance);
            request.getRequestDispatcher("/WEB-INF/views/origin/analysis.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "获取生源地分析失败: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
} 