package org.example.demo111.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.example.demo111.dao.TeachingClassDAO;
import org.example.demo111.model.TeachingClass;

/**
 * 教学班服务类
 */
public class TeachingClassService {
    private final TeachingClassDAO teachingClassDAO;

    public TeachingClassService() {
        this.teachingClassDAO = new TeachingClassDAO();
    }

    /**
     * 获取所有教学班
     */
    public List<TeachingClass> getAllTeachingClasses() {
        try {
            return teachingClassDAO.getAllTeachingClasses();
        } catch (SQLException e) {
            throw new RuntimeException("获取教学班列表失败", e);
        }
    }

    /**
     * 根据ID获取教学班
     */
    public TeachingClass getTeachingClassById(Integer id) {
        try {
            return teachingClassDAO.getTeachingClassById(id);
        } catch (SQLException e) {
            throw new RuntimeException("获取教学班详情失败", e);
        }
    }

    /**
     * 添加教学班
     */
    public boolean addTeachingClass(TeachingClass teachingClass) {
        try {
            // 验证输入
            validateTeachingClass(teachingClass);
            
            // 检查是否冲突
            if (teachingClassDAO.isTeachingClassConflict(
                    teachingClass.getHylCno10(),
                    teachingClass.getHylTcyear10(),
                    teachingClass.getHylTcterm10(),
                    teachingClass.getHylTcbatch10(),
                    null)) {
                throw new RuntimeException("该课程在指定学期和班次已存在教学班");
            }
            
            return teachingClassDAO.addTeachingClass(teachingClass);
        } catch (SQLException e) {
            throw new RuntimeException("添加教学班失败", e);
        }
    }

    /**
     * 更新教学班
     */
    public boolean updateTeachingClass(TeachingClass teachingClass) {
        try {
            // 验证输入
            validateTeachingClass(teachingClass);
            
            // 检查是否冲突（排除当前记录）
            if (teachingClassDAO.isTeachingClassConflict(
                    teachingClass.getHylCno10(),
                    teachingClass.getHylTcyear10(),
                    teachingClass.getHylTcterm10(),
                    teachingClass.getHylTcbatch10(),
                    teachingClass.getHylTcno10())) {
                throw new RuntimeException("该课程在指定学期和班次已存在教学班");
            }
            
            return teachingClassDAO.updateTeachingClass(teachingClass);
        } catch (SQLException e) {
            throw new RuntimeException("更新教学班失败", e);
        }
    }

    /**
     * 删除教学班
     */
    public boolean deleteTeachingClass(Integer id) {
        try {
            // 检查是否存在选课记录
            TeachingClass teachingClass = teachingClassDAO.getTeachingClassById(id);
            if (teachingClass != null && teachingClass.getHylTccurstu10() > 0) {
                throw new RuntimeException("该教学班已有学生选课，无法删除");
            }
            
            return teachingClassDAO.deleteTeachingClass(id);
        } catch (SQLException e) {
            throw new RuntimeException("删除教学班失败", e);
        }
    }

    /**
     * 搜索教学班
     */
    public List<TeachingClass> searchTeachingClasses(String keyword) {
        try {
            if (keyword == null || keyword.trim().isEmpty()) {
                return getAllTeachingClasses();
            }
            return teachingClassDAO.searchTeachingClasses(keyword.trim());
        } catch (SQLException e) {
            throw new RuntimeException("搜索教学班失败", e);
        }
    }

    /**
     * 获取可用的课程列表
     */
    public List<Map<String, Object>> getAvailableCourses() {
        try {
            return teachingClassDAO.getAvailableCourses();
        } catch (SQLException e) {
            throw new RuntimeException("获取课程列表失败", e);
        }
    }

    /**
     * 获取可用的教师列表
     */
    public List<Map<String, Object>> getAvailableTeachers() {
        try {
            return teachingClassDAO.getAvailableTeachers();
        } catch (SQLException e) {
            throw new RuntimeException("获取教师列表失败", e);
        }
    }

    /**
     * 获取教学班统计信息
     */
    public Map<String, Object> getTeachingClassStats() {
        try {
            return teachingClassDAO.getTeachingClassStats();
        } catch (SQLException e) {
            throw new RuntimeException("获取教学班统计信息失败", e);
        }
    }

    /**
     * 验证教学班信息
     */
    private void validateTeachingClass(TeachingClass teachingClass) {
        if (teachingClass == null) {
            throw new IllegalArgumentException("教学班信息不能为空");
        }
        
        if (teachingClass.getHylTcname10() == null || teachingClass.getHylTcname10().trim().isEmpty()) {
            throw new IllegalArgumentException("教学班名称不能为空");
        }
        
        if (teachingClass.getHylTcyear10() == null || teachingClass.getHylTcyear10() < 2020) {
            throw new IllegalArgumentException("学年必须大于等于2020");
        }
        
        if (teachingClass.getHylTcterm10() == null || 
            teachingClass.getHylTcterm10() < 1 || teachingClass.getHylTcterm10() > 3) {
            throw new IllegalArgumentException("学期必须为1、2或3");
        }
        
        if (teachingClass.getHylTcrepeat10() == null || 
            (!teachingClass.getHylTcrepeat10().equals("重修班") && 
             !teachingClass.getHylTcrepeat10().equals("非重修班"))) {
            throw new IllegalArgumentException("重修班类型必须为'重修班'或'非重修班'");
        }
        
        if (teachingClass.getHylTcbatch10() == null || teachingClass.getHylTcbatch10().trim().isEmpty()) {
            throw new IllegalArgumentException("班次编号不能为空");
        }
        
        if (teachingClass.getHylTcmaxstu10() == null || teachingClass.getHylTcmaxstu10() <= 0) {
            throw new IllegalArgumentException("最大学生数必须大于0");
        }
        
        if (teachingClass.getHylCno10() == null) {
            throw new IllegalArgumentException("课程不能为空");
        }
        
        if (teachingClass.getHylTno10() == null) {
            throw new IllegalArgumentException("教师不能为空");
        }
    }

    /**
     * 生成教学班名称建议
     */
    public String generateTeachingClassName(String courseName, String batch) {
        if (courseName == null || courseName.trim().isEmpty()) {
            return "";
        }
        if (batch == null || batch.trim().isEmpty()) {
            batch = "01";
        }
        return courseName + "-" + batch + "班";
    }
} 