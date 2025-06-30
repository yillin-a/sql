package org.example.demo111.model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 选课成绩实体类
 */
public class Enrollment {
    private Integer hylSno10;           // 学号
    private Integer hylTcno10;          // 教学班编号
    private Integer hylEscore10;        // 成绩
    private BigDecimal hylEgpa10;       // GPA
    private Boolean hylOpen10;          // 是否开放
    private Date hylEnrolldate10;       // 选课时间
    private String hylStatus10;         // 状态
    
    // 关联字段
    private String studentName;         // 学生姓名
    private String courseName;          // 课程名称
    private String teacherName;         // 教师姓名
    private String teachingClassName;   // 教学班名称
    private Integer year;               // 学年
    private Integer term;               // 学期
    private BigDecimal courseCredit;    // 课程学分
    
    // 统计字段
    private Double averageScore;        // 平均成绩
    private Integer maxScore;           // 最高分
    private Integer minScore;           // 最低分
    private Integer studentCount;       // 学生数量
    private String scoreDistribution;   // 成绩分布
    
    // 非数据库字段，用于统计
    private Double passRate;
    
    // 总体统计字段
    private Integer totalCourses;
    private Integer totalEnrollments;
    private Double overallAverageScore;
    private Double overallPassRate;
    
    // 构造函数
    public Enrollment() {}
    
    public Enrollment(Integer hylSno10, Integer hylTcno10, Integer hylEscore10) {
        this.hylSno10 = hylSno10;
        this.hylTcno10 = hylTcno10;
        this.hylEscore10 = hylEscore10;
    }
    
    // Getter和Setter方法
    public Integer getHylSno10() { return hylSno10; }
    public void setHylSno10(Integer hylSno10) { this.hylSno10 = hylSno10; }
    
    public Integer getHylTcno10() { return hylTcno10; }
    public void setHylTcno10(Integer hylTcno10) { this.hylTcno10 = hylTcno10; }
    
    public Integer getHylEscore10() { return hylEscore10; }
    public void setHylEscore10(Integer hylEscore10) { this.hylEscore10 = hylEscore10; }
    
    public BigDecimal getHylEgpa10() { return hylEgpa10; }
    public void setHylEgpa10(BigDecimal hylEgpa10) { this.hylEgpa10 = hylEgpa10; }
    
    public Boolean getHylOpen10() { return hylOpen10; }
    public void setHylOpen10(Boolean hylOpen10) { this.hylOpen10 = hylOpen10; }
    
    public Date getHylEnrolldate10() { return hylEnrolldate10; }
    public void setHylEnrolldate10(Date hylEnrolldate10) { this.hylEnrolldate10 = hylEnrolldate10; }
    
    public String getHylStatus10() { return hylStatus10; }
    public void setHylStatus10(String hylStatus10) { this.hylStatus10 = hylStatus10; }
    
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    
    public String getTeacherName() { return teacherName; }
    public void setTeacherName(String teacherName) { this.teacherName = teacherName; }
    
    public String getTeachingClassName() { return teachingClassName; }
    public void setTeachingClassName(String teachingClassName) { this.teachingClassName = teachingClassName; }
    
    public Integer getYear() { return year; }
    public void setYear(Integer year) { this.year = year; }
    
    public Integer getTerm() { return term; }
    public void setTerm(Integer term) { this.term = term; }
    
    public BigDecimal getCourseCredit() { return courseCredit; }
    public void setCourseCredit(BigDecimal courseCredit) { this.courseCredit = courseCredit; }
    
    public String getScoreDistribution() { return scoreDistribution; }
    public void setScoreDistribution(String scoreDistribution) { this.scoreDistribution = scoreDistribution; }
    
    public Double getAverageScore() { return averageScore; }
    public void setAverageScore(Double averageScore) { this.averageScore = averageScore; }
    
    public Integer getMaxScore() { return maxScore; }
    public void setMaxScore(Integer maxScore) { this.maxScore = maxScore; }
    
    public Integer getMinScore() { return minScore; }
    public void setMinScore(Integer minScore) { this.minScore = minScore; }
    
    public Integer getStudentCount() { return studentCount; }
    public void setStudentCount(Integer studentCount) { this.studentCount = studentCount; }
    
    public Double getPassRate() { return passRate; }
    public void setPassRate(Double passRate) { this.passRate = passRate; }
    
    public Integer getTotalCourses() { return totalCourses; }
    public void setTotalCourses(Integer totalCourses) { this.totalCourses = totalCourses; }
    
    public Integer getTotalEnrollments() { return totalEnrollments; }
    public void setTotalEnrollments(Integer totalEnrollments) { this.totalEnrollments = totalEnrollments; }
    
    public Double getOverallAverageScore() { return overallAverageScore; }
    public void setOverallAverageScore(Double overallAverageScore) { this.overallAverageScore = overallAverageScore; }
    
    public Double getOverallPassRate() { return overallPassRate; }
    public void setOverallPassRate(Double overallPassRate) { this.overallPassRate = overallPassRate; }
    
    @Override
    public String toString() {
        return "Enrollment{" +
                "hylSno10=" + hylSno10 +
                ", hylTcno10=" + hylTcno10 +
                ", hylEscore10=" + hylEscore10 +
                ", studentName='" + studentName + '\'' +
                ", courseName='" + courseName + '\'' +
                ", teacherName='" + teacherName + '\'' +
                ", year=" + year +
                ", term=" + term +
                '}';
    }
} 