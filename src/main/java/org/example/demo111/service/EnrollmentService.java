package org.example.demo111.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.example.demo111.dao.EnrollmentDAO;
import org.example.demo111.model.Enrollment;
import org.example.demo111.util.GPAConverter;

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
     * 搜索选课记录
     */
    public List<Enrollment> searchEnrollments(String studentName, String courseName) {
        try {
            return enrollmentDAO.search(studentName, courseName);
        } catch (SQLException e) {
            throw new RuntimeException("搜索选课记录失败", e);
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

        // 当分数更新时，自动计算并更新GPA
        Integer score = enrollment.getHylEscore10();
        if (score != null) {
            BigDecimal gpa = BigDecimal.valueOf(GPAConverter.scoreToGPACustom(score));
            enrollment.setHylEgpa10(gpa);
        } else {
            enrollment.setHylEgpa10(null);
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
        
        if (enrollment.getHylSno10() == null || enrollment.getHylTcno10() == null) {
            return false;
        }
        
        // 验证成绩
        if (enrollment.getHylEscore10() != null) {
            return validateScore(enrollment.getHylEscore10());
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

    /**
     * 获取学生可选的教学班列表
     */
    public List<Map<String, Object>> getAvailableTeachingClasses(Integer studentId) {
        try {
            return enrollmentDAO.getAvailableTeachingClasses(studentId);
        } catch (SQLException e) {
            throw new RuntimeException("获取可选教学班失败", e);
        }
    }

    /**
     * 获取学生已选的教学班列表
     */
    public List<Map<String, Object>> getEnrolledTeachingClasses(Integer studentId) {
        try {
            return enrollmentDAO.getEnrolledTeachingClasses(studentId);
        } catch (SQLException e) {
            throw new RuntimeException("获取已选教学班失败", e);
        }
    }

    /**
     * 学生选课（选择教学班）
     */
    public boolean selectCourse(Integer studentId, Integer teachingClassId) {
        try {
            // 检查是否已经选过这个教学班
            Enrollment existingEnrollment = enrollmentDAO.findByStudentAndCourse(studentId, teachingClassId);
            if (existingEnrollment != null) {
                throw new RuntimeException("您已经选择了这个教学班");
            }

            // 创建新的选课记录
            Enrollment enrollment = new Enrollment();
            enrollment.setHylSno10(studentId);
            enrollment.setHylTcno10(teachingClassId);
            enrollment.setHylStatus10("正常");
            enrollment.setHylOpen10(false); // 成绩默认不开放
            enrollment.setHylEnrolldate10(new java.util.Date());

            return enrollmentDAO.addEnrollment(enrollment);
        } catch (SQLException e) {
            throw new RuntimeException("选课失败: " + e.getMessage(), e);
        }
    }

    /**
     * 学生退选课程
     */
    public boolean dropCourse(Integer studentId, Integer teachingClassId) {
        try {
            // 检查选课记录是否存在
            Enrollment enrollment = enrollmentDAO.findByStudentAndCourse(studentId, teachingClassId);
            if (enrollment == null) {
                throw new RuntimeException("您没有选择这个教学班，无法退选");
            }

            // 检查是否已经有成绩，如果有成绩则不能退选
            if (enrollment.getHylEscore10() != null && enrollment.getHylEscore10() > 0) {
                throw new RuntimeException("该课程已有成绩，无法退选");
            }

            System.out.println("Before calling enrollmentDAO.deleteEnrollment");
            return enrollmentDAO.deleteEnrollment(studentId, teachingClassId);
        } catch (SQLException e) {
            throw new RuntimeException("退选失败: " + e.getMessage(), e);
        }
    }
    
    /**
     * 根据教师ID获取该教师所教授的所有选课记录
     */
    public List<Enrollment> getEnrollmentsByTeacherId(Integer teacherId) {
        try {
            return enrollmentDAO.findByTeacherId(teacherId);
        } catch (SQLException e) {
            throw new RuntimeException("获取教师选课记录失败", e);
        }
    }
    
    /**
     * 根据教师ID和搜索条件查询选课记录
     */
    public List<Enrollment> searchEnrollmentsByTeacherId(Integer teacherId, String studentName, String courseName) {
        try {
            return enrollmentDAO.searchByTeacherId(teacherId, studentName, courseName);
        } catch (SQLException e) {
            throw new RuntimeException("搜索教师选课记录失败", e);
        }
    }
} 