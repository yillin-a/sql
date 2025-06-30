package org.example.demo111.service;

import org.example.demo111.dao.EnrollmentDAO;
import org.example.demo111.model.Enrollment;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

/**
 * 课程成绩统计服务类
 */
public class CourseScoreStatisticsService {
    private final EnrollmentDAO enrollmentDAO;
    
    public CourseScoreStatisticsService() {
        this.enrollmentDAO = new EnrollmentDAO();
    }
    
    /**
     * 获取课程平均成绩统计
     */
    public List<Enrollment> getCourseAverageScores() {
        try {
            return enrollmentDAO.findCourseAverageScores();
        } catch (SQLException e) {
            throw new RuntimeException("获取课程平均成绩失败", e);
        }
    }
    
    /**
     * 按课程名称搜索课程平均成绩
     */
    public List<Enrollment> getCourseAverageScoresByCourseName(String courseName) {
        try {
            return enrollmentDAO.findCourseAverageScoresByCourseName(courseName);
        } catch (SQLException e) {
            throw new RuntimeException("搜索课程平均成绩失败", e);
        }
    }
    
    /**
     * 获取课程成绩排名
     */
    public List<Enrollment> getCourseScoreRanking() {
        try {
            List<Enrollment> enrollments = enrollmentDAO.findCourseAverageScores();
            // 按平均成绩排序（已经是降序，这里确保一下）
            enrollments.sort((e1, e2) -> Double.compare(e2.getAverageScore(), e1.getAverageScore()));
            return enrollments;
        } catch (SQLException e) {
            throw new RuntimeException("获取课程成绩排名失败", e);
        }
    }
    
    /**
     * 获取课程成绩排名（Map格式）
     */
    public List<Map<String, Object>> getCourseScoreRankingAsMap() {
        try {
            List<Enrollment> enrollments = enrollmentDAO.findCourseAverageScores();
            // 按平均成绩排序
            enrollments.sort((e1, e2) -> Double.compare(e2.getAverageScore(), e1.getAverageScore()));
            
            // 转换为Map格式并添加排名
            return enrollments.stream()
                .map(enrollment -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("courseName", enrollment.getCourseName());
                    map.put("teacherName", enrollment.getTeacherName());
                    map.put("studentCount", enrollment.getStudentCount());
                    map.put("avgScore", enrollment.getAverageScore());
                    map.put("maxScore", enrollment.getMaxScore());
                    map.put("minScore", enrollment.getMinScore());
                    map.put("scoreDistribution", enrollment.getScoreDistribution());
                    return map;
                })
                .collect(Collectors.toList());
        } catch (SQLException e) {
            throw new RuntimeException("获取课程成绩排名失败", e);
        }
    }
    
    /**
     * 获取课程成绩分布统计
     */
    public Map<String, Object> getCourseScoreDistribution() {
        try {
            List<Enrollment> enrollments = enrollmentDAO.findCourseAverageScores();
            Map<String, Object> distribution = new HashMap<>();
            
            // 计算各等级课程数量
            long excellentCourses = enrollments.stream()
                .filter(e -> e.getAverageScore() >= 90)
                .count();
            long goodCourses = enrollments.stream()
                .filter(e -> e.getAverageScore() >= 80 && e.getAverageScore() < 90)
                .count();
            long averageCourses = enrollments.stream()
                .filter(e -> e.getAverageScore() >= 70 && e.getAverageScore() < 80)
                .count();
            long passCourses = enrollments.stream()
                .filter(e -> e.getAverageScore() >= 60 && e.getAverageScore() < 70)
                .count();
            long failCourses = enrollments.stream()
                .filter(e -> e.getAverageScore() < 60)
                .count();
            
            distribution.put("excellent", excellentCourses);
            distribution.put("good", goodCourses);
            distribution.put("average", averageCourses);
            distribution.put("pass", passCourses);
            distribution.put("fail", failCourses);
            distribution.put("total", enrollments.size());
            
            return distribution;
        } catch (SQLException e) {
            throw new RuntimeException("获取课程成绩分布统计失败", e);
        }
    }
    
    /**
     * 获取教师课程成绩统计
     */
    public List<Enrollment> getTeacherCourseStatistics() {
        try {
            // 这里可以扩展为按教师统计课程成绩
            return enrollmentDAO.findCourseAverageScores();
        } catch (SQLException e) {
            throw new RuntimeException("获取教师课程成绩统计失败", e);
        }
    }
    
    /**
     * 计算课程成绩趋势（如果有时间数据）
     */
    public Map<String, Object> getCourseScoreTrend() {
        Map<String, Object> trend = new HashMap<>();
        // 这里可以添加时间序列分析
        // 暂时返回空数据
        trend.put("message", "时间序列分析功能待实现");
        return trend;
    }
    
    /**
     * 获取课程成绩异常检测
     */
    public List<Enrollment> getAbnormalCourseScores() {
        try {
            List<Enrollment> enrollments = enrollmentDAO.findCourseAverageScores();
            
            // 计算平均分和标准差
            double avgScore = enrollments.stream()
                .mapToDouble(Enrollment::getAverageScore)
                .average()
                .orElse(0.0);
            
            double variance = enrollments.stream()
                .mapToDouble(e -> Math.pow(e.getAverageScore() - avgScore, 2))
                .average()
                .orElse(0.0);
            double stdDev = Math.sqrt(variance);
            
            // 找出异常值（超过2个标准差）
            return enrollments.stream()
                .filter(e -> Math.abs(e.getAverageScore() - avgScore) > 2 * stdDev)
                .collect(Collectors.toList());
        } catch (SQLException e) {
            throw new RuntimeException("获取异常课程成绩失败", e);
        }
    }
} 