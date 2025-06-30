package org.example.demo111.service;

import org.example.demo111.dao.CourseDAO;
import org.example.demo111.model.Course;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * 课程服务类
 */
public class CourseService {
    private final CourseDAO courseDAO;
    
    public CourseService() {
        this.courseDAO = new CourseDAO();
    }
    
    /**
     * 获取所有课程
     */
    public List<Course> getAllCourses() throws SQLException {
        return courseDAO.findAll();
    }
    
    /**
     * 根据课程编号获取课程
     */
    public Course getCourseById(Integer courseId) throws SQLException {
        return courseDAO.findByCourseId(courseId);
    }
    
    /**
     * 根据课程名称搜索课程
     */
    public List<Course> searchCoursesByName(String name) throws SQLException {
        return courseDAO.findByName(name);
    }
    
    /**
     * 根据课程类型获取课程
     */
    public List<Course> getCoursesByType(String type) throws SQLException {
        return courseDAO.findByType(type);
    }
    
    /**
     * 添加课程
     */
    public boolean addCourse(Course course) throws SQLException {
        // 验证课程信息
        if (course.getHylCname10() == null || course.getHylCname10().trim().isEmpty()) {
            throw new IllegalArgumentException("课程名称不能为空");
        }
        
        if (course.getHylCcredit10() == null || course.getHylCcredit10().doubleValue() <= 0) {
            throw new IllegalArgumentException("学分必须大于0");
        }
        
        if (course.getHylChour10() == null || course.getHylChour10() <= 0) {
            throw new IllegalArgumentException("学时必须大于0");
        }
        
        if (course.getHylCtest10() == null || course.getHylCtest10().trim().isEmpty()) {
            throw new IllegalArgumentException("考核方式不能为空");
        }
        
        if (course.getHylCtype10() == null || course.getHylCtype10().trim().isEmpty()) {
            throw new IllegalArgumentException("课程类型不能为空");
        }
        
        return courseDAO.addCourse(course);
    }
    
    /**
     * 更新课程
     */
    public boolean updateCourse(Course course) throws SQLException {
        // 验证课程信息
        if (course.getHylCno10() == null) {
            throw new IllegalArgumentException("课程编号不能为空");
        }
        
        if (course.getHylCname10() == null || course.getHylCname10().trim().isEmpty()) {
            throw new IllegalArgumentException("课程名称不能为空");
        }
        
        if (course.getHylCcredit10() == null || course.getHylCcredit10().doubleValue() <= 0) {
            throw new IllegalArgumentException("学分必须大于0");
        }
        
        if (course.getHylChour10() == null || course.getHylChour10() <= 0) {
            throw new IllegalArgumentException("学时必须大于0");
        }
        
        if (course.getHylCtest10() == null || course.getHylCtest10().trim().isEmpty()) {
            throw new IllegalArgumentException("考核方式不能为空");
        }
        
        if (course.getHylCtype10() == null || course.getHylCtype10().trim().isEmpty()) {
            throw new IllegalArgumentException("课程类型不能为空");
        }
        
        return courseDAO.updateCourse(course);
    }
    
    /**
     * 删除课程
     */
    public boolean deleteCourse(Integer courseId) throws SQLException {
        if (courseId == null) {
            throw new IllegalArgumentException("课程编号不能为空");
        }
        
        // 检查课程是否被使用
        if (courseDAO.isCourseUsed(courseId)) {
            throw new IllegalStateException("该课程已被学生选课，无法删除");
        }
        
        return courseDAO.deleteCourse(courseId);
    }
    
    /**
     * 获取课程统计信息
     */
    public Map<String, Object> getCourseStats() throws SQLException {
        return courseDAO.getCourseStats();
    }
    
    /**
     * 获取课程成绩统计
     */
    public List<Map<String, Object>> getCourseScoreStats() throws SQLException {
        return courseDAO.getCourseScoreStats();
    }
    
    /**
     * 获取课程平均成绩详细统计（按教学班）
     */
    public List<Map<String, Object>> getCourseAverageScoreDetails() throws SQLException {
        return courseDAO.getCourseAverageScoreDetails();
    }
    
    /**
     * 按课程名称搜索课程平均成绩
     */
    public List<Map<String, Object>> getCourseAverageScoreByCourseName(String courseName) throws SQLException {
        if (courseName == null || courseName.trim().isEmpty()) {
            return getCourseAverageScoreDetails();
        }
        return courseDAO.getCourseAverageScoreByCourseName(courseName.trim());
    }
    
    /**
     * 获取课程平均成绩总体统计
     */
    public Map<String, Object> getCourseAverageScoreOverallStats() throws SQLException {
        return courseDAO.getCourseAverageScoreOverallStats();
    }
    
    /**
     * 按教师统计课程平均成绩
     */
    public List<Map<String, Object>> getCourseAverageScoreByTeacher() throws SQLException {
        return courseDAO.getCourseAverageScoreByTeacher();
    }
    
    /**
     * 检查课程是否被使用
     */
    public boolean isCourseUsed(Integer courseId) throws SQLException {
        return courseDAO.isCourseUsed(courseId);
    }
    
    /**
     * 获取学生可选的所有课程（可根据实际业务调整，这里简单返回所有课程）
     */
    public List<Map<String, Object>> getAllCoursesForSelection(Integer studentId) throws SQLException {
        return courseDAO.getAllCoursesForSelection(studentId);
    }
    
    public List<Map<String, Object>> findTeachingClassesByTeacherId(Integer teacherId) throws SQLException {
        return courseDAO.findTeachingClassesByTeacherId(teacherId);
    }

    public Course findByTeachingClassId(Integer teachingClassId) throws SQLException {
        return courseDAO.findByTeachingClassId(teachingClassId);
    }
} 