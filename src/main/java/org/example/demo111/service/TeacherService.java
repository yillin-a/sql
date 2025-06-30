package org.example.demo111.service;

import java.sql.SQLException;
import java.util.List;

import org.example.demo111.dao.TeacherDAO;
import org.example.demo111.model.Teacher;

/**
 * 教师业务逻辑服务类
 */
public class TeacherService {
    private final TeacherDAO teacherDAO;
    
    public TeacherService() {
        this.teacherDAO = new TeacherDAO();
    }
    
    /**
     * 获取所有教师
     */
    public List<Teacher> getAllTeachers() {
        try {
            return teacherDAO.findAll();
        } catch (SQLException e) {
            throw new RuntimeException("获取教师列表失败", e);
        }
    }
    
    /**
     * 根据教师编号获取教师
     */
    public Teacher getTeacherById(Integer teacherId) {
        try {
            return teacherDAO.findByTeacherId(teacherId);
        } catch (SQLException e) {
            throw new RuntimeException("获取教师信息失败", e);
        }
    }
    
    /**
     * 根据姓名搜索教师
     */
    public List<Teacher> searchTeachersByName(String name) {
        try {
            return teacherDAO.findByName(name);
        } catch (SQLException e) {
            throw new RuntimeException("搜索教师失败", e);
        }
    }
    
    /**
     * 根据职称查询教师
     */
    public List<Teacher> getTeachersByTitle(String title) {
        try {
            return teacherDAO.findByTitle(title);
        } catch (SQLException e) {
            throw new RuntimeException("根据职称查询教师失败", e);
        }
    }
    
    /**
     * 添加教师
     */
    public boolean addTeacher(Teacher teacher) {
        try {
            return teacherDAO.addTeacher(teacher);
        } catch (SQLException e) {
            throw new RuntimeException("添加教师失败", e);
        }
    }
    
    /**
     * 更新教师信息
     */
    public boolean updateTeacher(Teacher teacher) {
        try {
            return teacherDAO.updateTeacher(teacher);
        } catch (SQLException e) {
            throw new RuntimeException("更新教师信息失败", e);
        }
    }
    
    /**
     * 删除教师
     */
    public boolean deleteTeacher(Integer teacherId) {
        try {
            return teacherDAO.deleteTeacher(teacherId);
        } catch (SQLException e) {
            throw new RuntimeException("删除教师失败", e);
        }
    }
    
    /**
     * 更新教师状态
     */
    public boolean updateTeacherStatus(Integer teacherId, String status) {
        try {
            return teacherDAO.updateTeacherStatus(teacherId, status);
        } catch (SQLException e) {
            throw new RuntimeException("更新教师状态失败", e);
        }
    }
    
    /**
     * 获取在职教师
     */
    public List<Teacher> getActiveTeachers() {
        try {
            return teacherDAO.findActiveTeachers();
        } catch (SQLException e) {
            throw new RuntimeException("获取在职教师失败", e);
        }
    }
    
    /**
     * 更新教师个人资料（仅邮箱和电话）
     */
    public boolean updateTeacherProfile(Integer teacherId, String email, String phone) {
        try {
            return teacherDAO.updateTeacherProfile(teacherId, email, phone);
        } catch (SQLException e) {
            throw new RuntimeException("更新教师个人资料失败", e);
        }
    }
    
    /**
     * 验证教师信息
     */
    public boolean validateTeacher(Teacher teacher) {
        if (teacher == null) {
            return false;
        }
        
        // 验证姓名（必填）
        if (teacher.getHylTname10() == null || teacher.getHylTname10().trim().isEmpty()) {
            return false;
        }
        
        // 验证年龄（必填，22-70岁）
        if (teacher.getHylTage10() == null || teacher.getHylTage10() < 22 || teacher.getHylTage10() > 70) {
            return false;
        }
        
        // 验证性别（必填）
        if (teacher.getHylTsex10() == null || 
            (!"男".equals(teacher.getHylTsex10()) && !"女".equals(teacher.getHylTsex10()))) {
            return false;
        }
        
        // 验证职称（必填）
        if (teacher.getHylTtitle10() == null || teacher.getHylTtitle10().trim().isEmpty()) {
            return false;
        }
        
        // 验证邮箱格式（可选，但如果填写了就必须有@符号）
        if (teacher.getHylTemail10() != null && !teacher.getHylTemail10().trim().isEmpty() 
            && !teacher.getHylTemail10().contains("@")) {
            return false;
        }
        
        // 其他字段都是可选的，不需要验证
        
        return true;
    }
    
    /**
     * 验证职称
     */
    public boolean validateTitle(String title) {
        if (title == null) {
            return false;
        }
        
        String[] validTitles = {"教授", "副教授", "讲师", "助教", "无"};
        for (String validTitle : validTitles) {
            if (validTitle.equals(title)) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * 验证状态
     */
    public boolean validateStatus(String status) {
        if (status == null) {
            return false;
        }
        
        String[] validStatuses = {"在职", "离职", "退休"};
        for (String validStatus : validStatuses) {
            if (validStatus.equals(status)) {
                return true;
            }
        }
        
        return false;
    }
} 