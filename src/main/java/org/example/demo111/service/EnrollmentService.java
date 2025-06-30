package org.example.demo111.service;

import org.example.demo111.dao.EnrollmentDAO;
import org.example.demo111.model.Enrollment;
import org.example.demo111.util.GPAConverter;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * 选课成绩业务逻辑服务类
 */
public class EnrollmentService {
    private final EnrollmentDAO enrollmentDAO;
    
    public EnrollmentService() {
        this.enrollmentDAO = new EnrollmentDAO();
    }
    
    /**
     * 获取所有选课记录
     */
    public List<Enrollment> getAllEnrollments() {
        try {
            return enrollmentDAO.findAll();
        } catch (SQLException e) {
            throw new RuntimeException("获取选课记录失败", e);
        }
    }
    
    /**
     * 根据学号获取学生成绩
     */
    public List<Enrollment> getStudentScores(Integer studentId) {
        try {
            return enrollmentDAO.findByStudentId(studentId);
        } catch (SQLException e) {
            throw new RuntimeException("获取学生成绩失败", e);
        }
    }
    
    /**
     * 根据课程名称查询成绩
     */
    public List<Enrollment> getScoresByCourseName(String courseName) {
        try {
            return enrollmentDAO.findByCourseName(courseName);
        } catch (SQLException e) {
            throw new RuntimeException("获取课程成绩失败", e);
        }
    }
    
    /**
     * 添加选课记录
     */
    public boolean addEnrollment(Enrollment enrollment) {
        try {
            return enrollmentDAO.addEnrollment(enrollment);
        } catch (SQLException e) {
            throw new RuntimeException("添加选课记录失败", e);
        }
    }
    
    /**
     * 更新成绩
     */
    public boolean updateScore(Integer studentId, Integer teachingClassId, Integer score) {
        if (score != null && (score < 0 || score > 100)) {
            throw new IllegalArgumentException("成绩必须在0-100之间");
        }
        
        try {
            return enrollmentDAO.updateScore(studentId, teachingClassId, score);
        } catch (SQLException e) {
            throw new RuntimeException("更新成绩失败", e);
        }
    }
    
    /**
     * 更新成绩和GPA
     */
    public boolean updateScoreAndGPA(Integer studentId, Integer teachingClassId, Integer score) {
        if (score != null && (score < 0 || score > 100)) {
            throw new IllegalArgumentException("成绩必须在0-100之间");
        }
        
        try {
            BigDecimal gpa = score != null ? BigDecimal.valueOf(GPAConverter.scoreToGPACustom(score)) : null;
            return enrollmentDAO.updateScoreAndGPA(studentId, teachingClassId, score, gpa);
        } catch (SQLException e) {
            throw new RuntimeException("更新成绩和GPA失败", e);
        }
    }
    
    /**
     * 更新选课记录
     */
    public boolean updateEnrollment(Enrollment enrollment) {
        if (enrollment.getHylEscore10() != null && !validateScore(enrollment.getHylEscore10())) {
            throw new IllegalArgumentException("成绩必须在0-100之间");
        }
        try {
            return enrollmentDAO.updateEnrollment(enrollment);
        } catch (SQLException e) {
            throw new RuntimeException("更新选课记录失败", e);
        }
    }
    
    /**
     * 删除选课记录
     */
    public boolean deleteEnrollment(Integer studentId, Integer teachingClassId) {
        try {
            return enrollmentDAO.deleteEnrollment(studentId, teachingClassId);
        } catch (SQLException e) {
            throw new RuntimeException("删除选课记录失败", e);
        }
    }
    
    /**
     * 获取课程平均成绩
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
     * 计算学生平均成绩
     */
    public double calculateStudentAverageScore(Integer studentId) {
        List<Enrollment> scores = getStudentScores(studentId);
        if (scores.isEmpty()) {
            return 0.0;
        }
        
        double totalScore = 0.0;
        int count = 0;
        
        for (Enrollment enrollment : scores) {
            if (enrollment.getHylEscore10() != null) {
                totalScore += enrollment.getHylEscore10();
                count++;
            }
        }
        
        return count > 0 ? totalScore / count : 0.0;
    }
    
    /**
     * 验证成绩
     */
    public boolean validateScore(Integer score) {
        return score == null || (score >= 0 && score <= 100);
    }
    
    /**
     * 验证选课记录
     */
    public boolean validateEnrollment(Enrollment enrollment) {
        if (enrollment == null) {
            return false;
        }
        
        if (enrollment.getHylSno10() == null) {
            return false;
        }
        
        if (enrollment.getHylTcno10() == null) {
            return false;
        }
        
        if (enrollment.getHylEscore10() != null && !validateScore(enrollment.getHylEscore10())) {
            return false;
        }
        
        return true;
    }
    
    /**
     * 根据学号和教学班编号获取选课记录
     */
    public Enrollment getEnrollment(Integer studentId, Integer teachingClassId) {
        try {
            return enrollmentDAO.findByStudentIdAndTeachingClassId(studentId, teachingClassId);
        } catch (SQLException e) {
            throw new RuntimeException("获取选课记录失败", e);
        }
    }
    
    /**
     * 获取总体统计信息
     */
    public Enrollment getOverallStatistics() {
        try {
            return enrollmentDAO.findOverallStatistics();
        } catch (SQLException e) {
            throw new RuntimeException("获取总体统计信息失败", e);
        }
    }
    
    /**
     * 获取当前学期课表
     */
    public List<Map<String, Object>> getCurrentTermSchedule(Integer studentId) {
        try {
            return enrollmentDAO.getCurrentTermSchedule(studentId);
        } catch (SQLException e) {
            throw new RuntimeException("获取当前学期课表失败", e);
        }
    }
    
    /**
     * 获取GPA历史趋势
     */
    public List<Map<String, Object>> getGPAHistory(Integer studentId) {
        try {
            return enrollmentDAO.getGPAHistory(studentId);
        } catch (SQLException e) {
            throw new RuntimeException("获取GPA历史趋势失败", e);
        }
    }
    
    /**
     * 获取成绩分布统计
     */
    public Map<String, Integer> getScoreDistribution(Integer studentId) {
        try {
            return enrollmentDAO.getScoreDistribution(studentId);
        } catch (SQLException e) {
            throw new RuntimeException("获取成绩分布统计失败", e);
        }
    }
    
    /**
     * 批量更新所有学生的GPA
     */
    public boolean batchUpdateAllGPA() {
        try {
            return enrollmentDAO.batchUpdateGPA();
        } catch (SQLException e) {
            throw new RuntimeException("批量更新GPA失败", e);
        }
    }
    
    /**
     * 获取学生的总GPA
     */
    public BigDecimal getStudentTotalGPA(Integer studentId) {
        try {
            return enrollmentDAO.getStudentTotalGPA(studentId);
        } catch (SQLException e) {
            throw new RuntimeException("获取学生总GPA失败", e);
        }
    }
    
    /**
     * 获取学生的加权GPA
     */
    public BigDecimal getStudentWeightedGPA(Integer studentId) {
        try {
            return enrollmentDAO.getStudentWeightedGPA(studentId);
        } catch (SQLException e) {
            throw new RuntimeException("获取学生加权GPA失败", e);
        }
    }
    
    /**
     * 获取学生指定学期的GPA
     */
    public BigDecimal getStudentTermGPA(Integer studentId, Integer year, Integer term) {
        try {
            return enrollmentDAO.getStudentTermGPA(studentId, year, term);
        } catch (SQLException e) {
            throw new RuntimeException("获取学生学期GPA失败", e);
        }
    }
    
    /**
     * 获取课程的平均GPA
     */
    public BigDecimal getCourseAverageGPA(Integer teachingClassId) {
        try {
            return enrollmentDAO.getCourseAverageGPA(teachingClassId);
        } catch (SQLException e) {
            throw new RuntimeException("获取课程平均GPA失败", e);
        }
    }
    
    /**
     * 获取GPA分布统计
     */
    public Map<String, Integer> getGPADistribution(Integer teachingClassId) {
        try {
            return enrollmentDAO.getGPADistribution(teachingClassId);
        } catch (SQLException e) {
            throw new RuntimeException("获取GPA分布统计失败", e);
        }
    }
    
    /**
     * 获取学生GPA排名
     */
    public Integer getStudentGPARank(Integer studentId) {
        try {
            return enrollmentDAO.getStudentGPARank(studentId);
        } catch (SQLException e) {
            throw new RuntimeException("获取学生GPA排名失败", e);
        }
    }
    
    /**
     * 获取学生GPA历史记录
     */
    public List<Map<String, Object>> getStudentGPAHistory(Integer studentId) {
        try {
            return enrollmentDAO.getStudentGPAHistory(studentId);
        } catch (SQLException e) {
            throw new RuntimeException("获取学生GPA历史记录失败", e);
        }
    }
    
    /**
     * 计算学生GPA等级
     */
    public String getStudentGPAGrade(Integer studentId) {
        BigDecimal gpa = getStudentWeightedGPA(studentId);
        return GPAConverter.gpaToGrade(gpa.doubleValue());
    }
    
    /**
     * 根据分数计算GPA
     */
    public double calculateGPAFromScore(Integer score) {
        if (score == null) {
            return 0.0;
        }
        return GPAConverter.scoreToGPACustom(score);
    }
    
    /**
     * 根据分数获取等级
     */
    public String getGradeFromScore(Integer score) {
        if (score == null) {
            return "未录入";
        }
        return GPAConverter.scoreToGrade(score);
    }

    public List<Enrollment> findEnrollmentsByTeachingClassId(Integer teachingClassId) throws SQLException {
        return enrollmentDAO.findEnrollmentsByTeachingClassId(teachingClassId);
    }
    
    public Enrollment getEnrollmentByIds(int studentId, int teachingClassId) throws SQLException {
        return enrollmentDAO.findByStudentIdAndTeachingClassId(studentId, teachingClassId);
    }
} 