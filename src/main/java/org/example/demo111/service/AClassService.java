package org.example.demo111.service;

import java.sql.SQLException;
import java.util.List;

import org.example.demo111.dao.AClassDAO;
import org.example.demo111.model.AClass;

/**
 * 行政班服务类
 */
public class AClassService {
    private final AClassDAO aClassDAO;

    public AClassService() {
        this.aClassDAO = new AClassDAO();
    }

    /**
     * 获取所有行政班
     */
    public List<AClass> getAllAClasses() {
        try {
            return aClassDAO.getAllAClasses();
        } catch (SQLException e) {
            throw new RuntimeException("获取行政班列表失败", e);
        }
    }

    /**
     * 根据ID获取行政班
     */
    public AClass getAClassById(Integer id) {
        try {
            return aClassDAO.getAClassById(id);
        } catch (SQLException e) {
            throw new RuntimeException("获取行政班详情失败", e);
        }
    }

    /**
     * 根据专业获取行政班列表
     */
    public List<AClass> getAClassesByMajor(Integer majorId) {
        try {
            return aClassDAO.getAClassesByMajor(majorId);
        } catch (SQLException e) {
            throw new RuntimeException("获取专业行政班列表失败", e);
        }
    }

    /**
     * 添加行政班
     */
    public boolean addAClass(AClass aClass) {
        try {
            // 验证输入
            validateAClass(aClass);
            
            // 检查是否冲突
            if (aClassDAO.isAClassConflict(aClass.getHylAcname10(), aClass.getHylMno10(), null)) {
                throw new RuntimeException("该专业已存在同名行政班");
            }
            
            return aClassDAO.addAClass(aClass);
        } catch (SQLException e) {
            throw new RuntimeException("添加行政班失败", e);
        }
    }

    /**
     * 更新行政班
     */
    public boolean updateAClass(AClass aClass) {
        try {
            // 验证输入
            validateAClass(aClass);
            
            // 检查是否冲突（排除当前记录）
            if (aClassDAO.isAClassConflict(aClass.getHylAcname10(), aClass.getHylMno10(), aClass.getHylAcno10())) {
                throw new RuntimeException("该专业已存在同名行政班");
            }
            
            return aClassDAO.updateAClass(aClass);
        } catch (SQLException e) {
            throw new RuntimeException("更新行政班失败", e);
        }
    }

    /**
     * 删除行政班
     */
    public boolean deleteAClass(Integer id) {
        try {
            // 检查是否存在学生
            if (aClassDAO.hasStudents(id)) {
                throw new RuntimeException("该行政班已有学生，无法删除");
            }
            
            return aClassDAO.deleteAClass(id);
        } catch (SQLException e) {
            throw new RuntimeException("删除行政班失败", e);
        }
    }

    /**
     * 搜索行政班
     */
    public List<AClass> searchAClasses(String keyword) {
        try {
            if (keyword == null || keyword.trim().isEmpty()) {
                return getAllAClasses();
            }
            return aClassDAO.searchAClasses(keyword.trim());
        } catch (SQLException e) {
            throw new RuntimeException("搜索行政班失败", e);
        }
    }

    /**
     * 验证行政班信息
     */
    private void validateAClass(AClass aClass) {
        if (aClass == null) {
            throw new IllegalArgumentException("行政班对象不能为空");
        }
        
        // 验证行政班名称
        if (aClass.getHylAcname10() == null || aClass.getHylAcname10().trim().isEmpty()) {
            throw new IllegalArgumentException("行政班名称不能为空");
        }
        
        if (aClass.getHylAcname10().trim().length() > 50) {
            throw new IllegalArgumentException("行政班名称长度不能超过50个字符");
        }
        
        // 验证入学年份
        if (aClass.getHylAcyear10() == null || aClass.getHylAcyear10() < 2020) {
            throw new IllegalArgumentException("入学年份不能早于2020年");
        }
        
        // 验证班级人数上限
        if (aClass.getHylAcmaxstu10() == null || aClass.getHylAcmaxstu10() <= 0) {
            throw new IllegalArgumentException("班级人数上限必须是正整数");
        }
        
        if (aClass.getHylAcmaxstu10() > 100) {
            throw new IllegalArgumentException("班级人数上限不能超过100人");
        }
        
        // 验证专业编号
        if (aClass.getHylMno10() == null || aClass.getHylMno10() <= 0) {
            throw new IllegalArgumentException("专业编号无效");
        }
    }
} 