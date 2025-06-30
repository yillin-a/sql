package org.example.demo111.model;

import java.math.BigDecimal;

/**
 * 课程实体类
 */
public class Course {
    private Integer hylCno10;           // 课程编号
    private String hylCname10;          // 课程名称
    private BigDecimal hylCcredit10;    // 学分
    private Integer hylChour10;         // 学时
    private String hylCtest10;          // 考核方式
    private String hylCtype10;          // 课程类型
    private String hylCprereq10;        // 先修课程
    private String hylCdesc10;          // 课程描述
    private BigDecimal hylCavgscore10;  // 平均成绩
    
    // 构造函数
    public Course() {}
    
    public Course(Integer hylCno10, String hylCname10, BigDecimal hylCcredit10, 
                  Integer hylChour10, String hylCtest10, String hylCtype10) {
        this.hylCno10 = hylCno10;
        this.hylCname10 = hylCname10;
        this.hylCcredit10 = hylCcredit10;
        this.hylChour10 = hylChour10;
        this.hylCtest10 = hylCtest10;
        this.hylCtype10 = hylCtype10;
    }
    
    // Getter和Setter方法
    public Integer getHylCno10() { return hylCno10; }
    public void setHylCno10(Integer hylCno10) { this.hylCno10 = hylCno10; }
    
    public String getHylCname10() { return hylCname10; }
    public void setHylCname10(String hylCname10) { this.hylCname10 = hylCname10; }
    
    public BigDecimal getHylCcredit10() { return hylCcredit10; }
    public void setHylCcredit10(BigDecimal hylCcredit10) { this.hylCcredit10 = hylCcredit10; }
    
    public Integer getHylChour10() { return hylChour10; }
    public void setHylChour10(Integer hylChour10) { this.hylChour10 = hylChour10; }
    
    public String getHylCtest10() { return hylCtest10; }
    public void setHylCtest10(String hylCtest10) { this.hylCtest10 = hylCtest10; }
    
    public String getHylCtype10() { return hylCtype10; }
    public void setHylCtype10(String hylCtype10) { this.hylCtype10 = hylCtype10; }
    
    public String getHylCprereq10() { return hylCprereq10; }
    public void setHylCprereq10(String hylCprereq10) { this.hylCprereq10 = hylCprereq10; }
    
    public String getHylCdesc10() { return hylCdesc10; }
    public void setHylCdesc10(String hylCdesc10) { this.hylCdesc10 = hylCdesc10; }
    
    public BigDecimal getHylCavgscore10() { return hylCavgscore10; }
    public void setHylCavgscore10(BigDecimal hylCavgscore10) { this.hylCavgscore10 = hylCavgscore10; }
    
    @Override
    public String toString() {
        return "Course{" +
                "hylCno10=" + hylCno10 +
                ", hylCname10='" + hylCname10 + '\'' +
                ", hylCcredit10=" + hylCcredit10 +
                ", hylChour10=" + hylChour10 +
                ", hylCtest10='" + hylCtest10 + '\'' +
                ", hylCtype10='" + hylCtype10 + '\'' +
                '}';
    }
} 