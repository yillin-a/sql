package org.example.demo111.util;

/**
 * GPA转换工具类
 * 根据分数转换为对应的GPA值
 */
public class GPAConverter {
    
    /**
     * 根据分数转换为GPA（标准公式）
     * 当分数>=60时，GPA=(分数-50)/10，保留一位小数
     * 当分数<60时，GPA=0
     * @param score 分数
     * @return GPA值
     */
    public static double scoreToGPA(double score) {
        if (score >= 60) {
            double gpa = (score - 50) / 10.0;
            // 保留一位小数
            return Math.round(gpa * 10.0) / 10.0;
        } else {
            return 0.0;
        }
    }
    
    /**
     * 根据分数转换为GPA（主要使用的方法）
     * 当分数>=60时，GPA=(分数-50)/10，保留一位小数
     * 当分数<60时，GPA=0
     * @param score 分数
     * @return GPA值
     */
    public static double scoreToGPACustom(double score) {
        return scoreToGPA(score);
    }
    
    /**
     * 根据分数转换为GPA（精确版本）
     * 当分数>=60时，GPA=(分数-50)/10，保留一位小数
     * 当分数<60时，GPA=0
     * @param score 分数
     * @return GPA值
     */
    public static double scoreToGPAPrecise(double score) {
        return scoreToGPA(score);
    }
    
    /**
     * 根据GPA转换为等级
     * @param gpa GPA值
     * @return 等级描述
     */
    public static String gpaToGrade(double gpa) {
        if (gpa >= 4.0) {
            return "优秀";
        } else if (gpa >= 3.0) {
            return "良好";
        } else if (gpa >= 2.0) {
            return "中等";
        } else if (gpa >= 1.0) {
            return "及格";
        } else {
            return "不及格";
        }
    }
    
    /**
     * 根据分数转换为等级
     * @param score 分数
     * @return 等级描述
     */
    public static String scoreToGrade(double score) {
        if (score >= 90) {
            return "优秀";
        } else if (score >= 80) {
            return "良好";
        } else if (score >= 70) {
            return "中等";
        } else if (score >= 60) {
            return "及格";
        } else {
            return "不及格";
        }
    }
    
    /**
     * 计算加权GPA
     * @param scores 分数数组
     * @param credits 学分数组
     * @return 加权GPA
     */
    public static double calculateWeightedGPA(double[] scores, double[] credits) {
        if (scores == null || credits == null || scores.length != credits.length) {
            return 0.0;
        }
        
        double totalGPA = 0.0;
        double totalCredits = 0.0;
        
        for (int i = 0; i < scores.length; i++) {
            double gpa = scoreToGPA(scores[i]);
            totalGPA += gpa * credits[i];
            totalCredits += credits[i];
        }
        
        return totalCredits > 0 ? Math.round((totalGPA / totalCredits) * 10.0) / 10.0 : 0.0;
    }
    
    /**
     * 获取GPA转换公式说明
     * @return 公式说明
     */
    public static String getGPAFormula() {
        return "GPA转换公式：分数>=60时，GPA=(分数-50)/10；分数<60时，GPA=0";
    }
    
    /**
     * 获取GPA转换示例
     * @return 转换示例
     */
    public static String getGPAExamples() {
        return "转换示例：\n" +
               "100分 → GPA=5.0\n" +
               "95分 → GPA=4.5\n" +
               "90分 → GPA=4.0\n" +
               "85分 → GPA=3.5\n" +
               "80分 → GPA=3.0\n" +
               "75分 → GPA=2.5\n" +
               "70分 → GPA=2.0\n" +
               "65分 → GPA=1.5\n" +
               "60分 → GPA=1.0\n" +
               "59分及以下 → GPA=0.0";
    }
} 