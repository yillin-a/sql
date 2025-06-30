package org.example.demo111.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.example.demo111.dao.MajorDAO;
import org.example.demo111.model.Major;

/**
 * 专业业务逻辑服务
 */
public class MajorService {
    private MajorDAO majorDAO;
    
    public MajorService() {
        this.majorDAO = new MajorDAO();
    }
    
    /**
     * 获取所有专业
     */
    public List<Major> getAllMajors() {
        try {
            return majorDAO.findAll();
        } catch (SQLException e) {
            throw new RuntimeException("获取专业列表失败", e);
        }
    }
    
    /**
     * 根据ID获取专业
     */
    public Major getMajorById(Integer majorId) {
        if (majorId == null || majorId <= 0) {
            throw new IllegalArgumentException("专业编号无效");
        }
        
        try {
            return majorDAO.findById(majorId);
        } catch (SQLException e) {
            throw new RuntimeException("获取专业信息失败", e);
        }
    }
    
    /**
     * 添加专业
     */
    public boolean addMajor(Major major, String errorMessage[]) {
        try {
            // 数据验证
            if (!validateMajor(major, errorMessage)) {
                return false;
            }
            
            // 检查同一学院内是否已存在同名专业
            Major existingMajor = majorDAO.findByNameAndFaculty(
                major.getHylMname10(), major.getHylFno10());
            if (existingMajor != null) {
                errorMessage[0] = "该学院已存在同名专业：" + major.getHylMname10();
                return false;
            }
            
            return majorDAO.addMajor(major);
        } catch (SQLException e) {
            errorMessage[0] = "添加专业失败：" + e.getMessage();
            return false;
        }
    }
    
    /**
     * 更新专业信息
     */
    public boolean updateMajor(Major major, String errorMessage[]) {
        try {
            // 数据验证
            if (!validateMajor(major, errorMessage)) {
                return false;
            }
            
            // 检查专业是否存在
            Major existingMajor = majorDAO.findById(major.getHylMno10());
            if (existingMajor == null) {
                errorMessage[0] = "专业不存在";
                return false;
            }
            
            // 检查同一学院内是否已存在同名专业（排除自己）
            Major duplicateMajor = majorDAO.findByNameAndFaculty(
                major.getHylMname10(), major.getHylFno10());
            if (duplicateMajor != null && !duplicateMajor.getHylMno10().equals(major.getHylMno10())) {
                errorMessage[0] = "该学院已存在同名专业：" + major.getHylMname10();
                return false;
            }
            
            return majorDAO.updateMajor(major);
        } catch (SQLException e) {
            errorMessage[0] = "更新专业失败：" + e.getMessage();
            return false;
        }
    }
    
    /**
     * 删除专业
     */
    public boolean deleteMajor(Integer majorId, String errorMessage[]) {
        if (majorId == null || majorId <= 0) {
            errorMessage[0] = "专业编号无效";
            return false;
        }
        
        try {
            // 检查专业是否存在
            Major major = majorDAO.findById(majorId);
            if (major == null) {
                errorMessage[0] = "专业不存在";
                return false;
            }
            
            // 检查是否存在学生
            if (majorDAO.hasStudents(majorId)) {
                errorMessage[0] = "该专业下存在学生，无法删除。请先转移或删除相关学生。";
                return false;
            }
            
            return majorDAO.deleteMajor(majorId);
        } catch (SQLException e) {
            errorMessage[0] = "删除专业失败：" + e.getMessage();
            return false;
        }
    }
    
    /**
     * 搜索专业
     */
    public List<Major> searchMajors(String keyword, Integer facultyId) {
        try {
            return majorDAO.searchMajors(keyword, facultyId);
        } catch (SQLException e) {
            throw new RuntimeException("搜索专业失败", e);
        }
    }
    
    /**
     * 获取专业统计信息
     */
    public Map<String, Object> getMajorStatistics() {
        try {
            return majorDAO.getMajorStatistics();
        } catch (SQLException e) {
            throw new RuntimeException("获取专业统计信息失败", e);
        }
    }
    
    /**
     * 获取学院专业分布
     */
    public List<Map<String, Object>> getFacultyMajorDistribution() {
        try {
            return majorDAO.getFacultyMajorDistribution();
        } catch (SQLException e) {
            throw new RuntimeException("获取学院专业分布失败", e);
        }
    }
    
    /**
     * 获取所有学院列表
     */
    public List<Map<String, Object>> getAllFaculties() {
        try {
            return majorDAO.getAllFaculties();
        } catch (SQLException e) {
            throw new RuntimeException("获取学院列表失败", e);
        }
    }
    
    /**
     * 验证专业数据
     */
    private boolean validateMajor(Major major, String errorMessage[]) {
        if (major == null) {
            errorMessage[0] = "专业对象不能为空";
            return false;
        }
        
        // 验证专业名称
        if (major.getHylMname10() == null || major.getHylMname10().trim().isEmpty()) {
            errorMessage[0] = "专业名称不能为空";
            return false;
        }
        
        if (major.getHylMname10().trim().length() > 50) {
            errorMessage[0] = "专业名称长度不能超过50个字符";
            return false;
        }
        
        // 验证学位类型
        if (major.getHylMdegree10() == null || major.getHylMdegree10().trim().isEmpty()) {
            errorMessage[0] = "学位类型不能为空";
            return false;
        }
        
        if (!major.getHylMdegree10().equals("本科") && 
            !major.getHylMdegree10().equals("硕士") && 
            !major.getHylMdegree10().equals("博士")) {
            errorMessage[0] = "学位类型必须是：本科、硕士或博士";
            return false;
        }
        
        // 验证学制年限
        if (major.getHylMyears10() == null || major.getHylMyears10() <= 0) {
            errorMessage[0] = "学制年限必须是正整数";
            return false;
        }
        
        if (major.getHylMyears10() > 10) {
            errorMessage[0] = "学制年限不能超过10年";
            return false;
        }
        
        // 验证所属学院
        if (major.getHylFno10() == null || major.getHylFno10() <= 0) {
            errorMessage[0] = "必须选择所属学院";
            return false;
        }
        
        return true;
    }
} 