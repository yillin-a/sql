package org.example.demo111.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.example.demo111.dao.StudentDAO;
import org.example.demo111.model.Student;

/**
 * 学生业务逻辑服务类
 */
public class StudentService {
    private final StudentDAO studentDAO;
    
    public StudentService() {
        this.studentDAO = new StudentDAO();
    }
    
    /**
     * 获取所有学生
     */
    public List<Student> getAllStudents() {
        try {
            return studentDAO.findAll();
        } catch (SQLException e) {
            throw new RuntimeException("获取学生列表失败", e);
        }
    }
    
    /**
     * 根据学号获取学生
     */
    public Student getStudentById(Integer studentId) {
        try {
            return studentDAO.findByStudentId(studentId);
        } catch (SQLException e) {
            throw new RuntimeException("获取学生信息失败", e);
        }
    }
    
    /**
     * 根据姓名搜索学生
     */
    public List<Student> searchStudentsByName(String name) {
        try {
            return studentDAO.findByName(name);
        } catch (SQLException e) {
            throw new RuntimeException("搜索学生失败", e);
        }
    }
    
    /**
     * 添加学生
     */
    public boolean addStudent(Student student) {
        try {
            return studentDAO.addStudent(student);
        } catch (SQLException e) {
            throw new RuntimeException("添加学生失败", e);
        }
    }
    
    /**
     * 更新学生信息
     */
    public boolean updateStudent(Student student) {
        try {
            return studentDAO.updateStudent(student);
        } catch (SQLException e) {
            throw new RuntimeException("更新学生信息失败", e);
        }
    }
    
    /**
     * 删除学生
     */
    public boolean deleteStudent(Integer studentId) {
        try {
            return studentDAO.deleteStudent(studentId);
        } catch (SQLException e) {
            throw new RuntimeException("删除学生失败", e);
        }
    }
    
    /**
     * 获取学生成绩排名
     */
    public List<Student> getStudentsWithScores() {
        try {
            return studentDAO.findStudentsWithScores();
        } catch (SQLException e) {
            throw new RuntimeException("获取学生成绩失败", e);
        }
    }
    
    /**
     * 获取学生详细成绩信息
     */
    public List<Map<String, Object>> getStudentScores(Integer studentId) {
        try {
            return studentDAO.getStudentScores(studentId);
        } catch (SQLException e) {
            throw new RuntimeException("获取学生详细成绩失败", e);
        }
    }
    
    /**
     * 获取学生成绩统计信息
     */
    public Map<String, Object> getStudentScoreStats(Integer studentId) {
        try {
            return studentDAO.getStudentScoreStats(studentId);
        } catch (SQLException e) {
            throw new RuntimeException("获取学生成绩统计失败", e);
        }
    }
    
    /**
     * 获取所有学生的成绩排名
     */
    public List<Map<String, Object>> getAllStudentsRanking() {
        try {
            return studentDAO.getAllStudentsRanking();
        } catch (SQLException e) {
            throw new RuntimeException("获取学生成绩排名失败", e);
        }
    }
    
    /**
     * 验证学生信息
     */
    public boolean validateStudent(Student student) {
        if (student == null) {
            return false;
        }
        
        // 验证姓名
        if (student.getHylSname10() == null || student.getHylSname10().trim().isEmpty()) {
            return false;
        }
        
        // 验证年龄
        if (student.getHylSage10() == null || student.getHylSage10() < 16 || student.getHylSage10() > 35) {
            return false;
        }
        
        // 验证性别
        if (student.getHylSsex10() == null || 
            (!"男".equals(student.getHylSsex10()) && !"女".equals(student.getHylSsex10()))) {
            return false;
        }
        
        // 验证籍贯
        if (student.getHylSplace10() == null || student.getHylSplace10().trim().isEmpty()) {
            return false;
        }
        
        // 验证专业编号
        if (student.getHylMno10() == null) {
            return false;
        }
        
        // 验证班级编号
        if (student.getHylAcno10() == null) {
            return false;
        }
        
        // 验证邮箱格式（如果提供）
        if (student.getHylSemail10() != null && !student.getHylSemail10().trim().isEmpty()) {
            if (!student.getHylSemail10().contains("@")) {
                return false;
            }
        }
        
        return true;
    }
    
    /**
     * 获取总体成绩统计
     */
    public Map<String, Object> getOverallScoreStats() {
        try {
            return studentDAO.getOverallScoreStats();
        } catch (SQLException e) {
            throw new RuntimeException("获取总体成绩统计失败", e);
        }
    }
    
    /**
     * 按专业获取成绩统计
     */
    public List<Map<String, Object>> getScoreStatsByMajor() {
        try {
            return studentDAO.getScoreStatsByMajor();
        } catch (SQLException e) {
            throw new RuntimeException("获取专业成绩统计失败", e);
        }
    }
    
    /**
     * 获取成绩分布
     */
    public Map<String, Object> getScoreDistribution() {
        try {
            return studentDAO.getScoreDistribution();
        } catch (SQLException e) {
            throw new RuntimeException("获取成绩分布失败", e);
        }
    }
    
    /**
     * 按专业获取成绩排名
     */
    public List<Map<String, Object>> getScoreRankingByMajor(String major) {
        try {
            return studentDAO.getScoreRankingByMajor(major);
        } catch (SQLException e) {
            throw new RuntimeException("获取专业成绩排名失败", e);
        }
    }
    
    /**
     * 获取总体成绩分析
     */
    public Map<String, Object> getOverallScoreAnalysis() {
        try {
            return studentDAO.getOverallScoreAnalysis();
        } catch (SQLException e) {
            throw new RuntimeException("获取总体成绩分析失败", e);
        }
    }
    
    /**
     * 按专业获取成绩分析
     */
    public Map<String, Object> getScoreAnalysisByMajor(String major) {
        try {
            return studentDAO.getScoreAnalysisByMajor(major);
        } catch (SQLException e) {
            throw new RuntimeException("获取专业成绩分析失败", e);
        }
    }
    
    /**
     * 按专业获取成绩分布
     */
    public Map<String, Object> getScoreDistributionByMajor(String major) {
        try {
            return studentDAO.getScoreDistributionByMajor(major);
        } catch (SQLException e) {
            throw new RuntimeException("获取专业成绩分布失败", e);
        }
    }
    
    /**
     * 获取生源地总体统计
     */
    public Map<String, Object> getOriginOverallStats() {
        try {
            return studentDAO.getOriginOverallStats();
        } catch (SQLException e) {
            throw new RuntimeException("获取生源地总体统计失败", e);
        }
    }
    
    /**
     * 获取生源地分布
     */
    public Map<String, Object> getOriginDistribution() {
        try {
            return studentDAO.getOriginDistribution();
        } catch (SQLException e) {
            throw new RuntimeException("获取生源地分布失败", e);
        }
    }
    
    /**
     * 获取生源地分布列表
     */
    public List<Map<String, Object>> getOriginDistributionList() {
        try {
            return studentDAO.getOriginDistributionList();
        } catch (SQLException e) {
            throw new RuntimeException("获取生源地分布列表失败", e);
        }
    }
    
    /**
     * 获取生源地排名
     */
    public List<Map<String, Object>> getOriginRanking() {
        try {
            return studentDAO.getOriginRanking();
        } catch (SQLException e) {
            throw new RuntimeException("获取生源地排名失败", e);
        }
    }
    
    /**
     * 获取生源地分析
     */
    public Map<String, Object> getOriginAnalysis() {
        try {
            return studentDAO.getOriginAnalysis();
        } catch (SQLException e) {
            throw new RuntimeException("获取生源地分析失败", e);
        }
    }
    
    /**
     * 获取生源地表现
     */
    public List<Map<String, Object>> getOriginPerformance() {
        try {
            return studentDAO.getOriginPerformance();
        } catch (SQLException e) {
            throw new RuntimeException("获取生源地表现失败", e);
        }
    }
    
    /**
     * 获取前N个生源地
     */
    public List<Map<String, Object>> getTopOrigins(int limit) {
        try {
            return studentDAO.getTopOrigins(limit);
        } catch (SQLException e) {
            throw new RuntimeException("获取前N个生源地失败", e);
        }
    }
    
    /**
     * 获取学生专业排名信息
     */
    public Map<String, Object> getStudentRanking(Integer studentId) {
        try {
            return studentDAO.getStudentRanking(studentId);
        } catch (SQLException e) {
            throw new RuntimeException("获取学生排名信息失败", e);
        }
    }
    
    /**
     * 更新学生个人信息（仅限邮箱、电话、籍贯）
     * @param studentId 学生ID
     * @param email 邮箱
     * @param phone 电话
     * @param place 籍贯
     * @return 是否更新成功
     */
    public boolean updateStudentProfile(Integer studentId, String email, String phone, String place) {
        try {
            return studentDAO.updateStudentProfile(studentId, email, phone, place);
        } catch (SQLException e) {
            throw new RuntimeException("更新学生个人信息失败", e);
        }
    }
    
    /**
     * 手动更新所有学生的GPA
     */
    public void updateAllStudentsGPA() {
        try {
            studentDAO.updateAllStudentsGPA();
        } catch (SQLException e) {
            throw new RuntimeException("更新学生GPA失败", e);
        }
    }
} 