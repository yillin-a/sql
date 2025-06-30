# GPA转换标准实现指南

## 功能概述

为教务管理系统添加了完整的GPA（Grade Point Average）转换功能，根据课程分数自动计算对应的GPA值，支持多种转换标准和统计功能。

## GPA转换标准

### 标准转换公式
```
当分数 >= 60时：GPA = (分数 - 50) / 10，保留一位小数
当分数 < 60时：GPA = 0.0
```

### 转换示例
```
100分 → GPA = 5.0
95分  → GPA = 4.5
90分  → GPA = 4.0
85分  → GPA = 3.5
80分  → GPA = 3.0
75分  → GPA = 2.5
70分  → GPA = 2.0
65分  → GPA = 1.5
60分  → GPA = 1.0
59分及以下 → GPA = 0.0
```

### GPA等级划分
```
GPA >= 4.0 → 优秀
GPA >= 3.0 → 良好
GPA >= 2.0 → 中等
GPA >= 1.0 → 及格
GPA < 1.0  → 不及格
```

## 技术实现

### 1. GPA转换工具类 (GPAConverter)

#### 主要方法
```java
// 标准转换（主要使用）
public static double scoreToGPA(double score)

// 自定义转换（与标准转换相同）
public static double scoreToGPACustom(double score)

// 精确转换（与标准转换相同）
public static double scoreToGPAPrecise(double score)

// 根据GPA转换为等级
public static String gpaToGrade(double gpa)

// 根据分数转换为等级
public static String scoreToGrade(double score)

// 计算加权GPA
public static double calculateWeightedGPA(double[] scores, double[] credits)

// 获取GPA转换公式说明
public static String getGPAFormula()

// 获取GPA转换示例
public static String getGPAExamples()
```

### 2. EnrollmentDAO 新增方法

#### GPA相关数据库操作
```java
// 更新成绩和GPA
public boolean updateScoreAndGPA(Integer studentId, Integer teachingClassId, Integer score, BigDecimal gpa)

// 批量更新GPA（根据成绩自动计算）
public boolean batchUpdateGPA()

// 获取学生的总GPA
public BigDecimal getStudentTotalGPA(Integer studentId)

// 获取学生的加权GPA
public BigDecimal getStudentWeightedGPA(Integer studentId)

// 获取学生指定学期的GPA
public BigDecimal getStudentTermGPA(Integer studentId, Integer year, Integer term)

// 获取课程的平均GPA
public BigDecimal getCourseAverageGPA(Integer teachingClassId)

// 获取GPA分布统计
public Map<String, Integer> getGPADistribution(Integer teachingClassId)

// 获取学生GPA排名
public Integer getStudentGPARank(Integer studentId)

// 获取学生GPA历史记录
public List<Map<String, Object>> getStudentGPAHistory(Integer studentId)
```

### 3. EnrollmentService 新增方法

#### GPA相关业务逻辑
```java
// 更新成绩和GPA
public boolean updateScoreAndGPA(Integer studentId, Integer teachingClassId, Integer score)

// 批量更新所有学生的GPA
public boolean batchUpdateAllGPA()

// 获取学生的总GPA
public BigDecimal getStudentTotalGPA(Integer studentId)

// 获取学生的加权GPA
public BigDecimal getStudentWeightedGPA(Integer studentId)

// 获取学生指定学期的GPA
public BigDecimal getStudentTermGPA(Integer studentId, Integer year, Integer term)

// 获取课程的平均GPA
public BigDecimal getCourseAverageGPA(Integer teachingClassId)

// 获取GPA分布统计
public Map<String, Integer> getGPADistribution(Integer teachingClassId)

// 获取学生GPA排名
public Integer getStudentGPARank(Integer studentId)

// 获取学生GPA历史记录
public List<Map<String, Object>> getStudentGPAHistory(Integer studentId)

// 计算学生GPA等级
public String getStudentGPAGrade(Integer studentId)

// 根据分数计算GPA
public double calculateGPAFromScore(Integer score)

// 根据分数获取等级
public String getGradeFromScore(Integer score)
```

### 4. GPAController

#### 主要功能
- GPA管理仪表板
- 学生GPA信息查看
- 课程GPA信息查看
- 成绩和GPA更新
- 批量GPA更新
- GPA分布统计
- GPA排名查看

## 数据库操作

### 1. 批量更新GPA SQL
```sql
UPDATE huyl_enroll10 SET hyl_egpa10 = CASE 
    WHEN hyl_escore10 >= 60 THEN ROUND((hyl_escore10 - 50) / 10.0, 1)
    ELSE 0.0 END 
WHERE hyl_escore10 IS NOT NULL
```

### 2. 加权GPA计算 SQL
```sql
SELECT SUM(e.hyl_egpa10 * c.hyl_ccredit10) / SUM(c.hyl_ccredit10) as weighted_gpa
FROM huyl_enroll10 e
JOIN huyl_tclass10 tc ON e.hyl_tcno10 = tc.hyl_tcno10
JOIN huyl_course10 c ON tc.hyl_cno10 = c.hyl_cno10
WHERE e.hyl_sno10 = ? AND e.hyl_escore10 IS NOT NULL
```

### 3. GPA分布统计 SQL
```sql
SELECT 
    SUM(CASE WHEN hyl_egpa10 >= 4.0 THEN 1 ELSE 0 END) as excellent,
    SUM(CASE WHEN hyl_egpa10 >= 3.0 AND hyl_egpa10 < 4.0 THEN 1 ELSE 0 END) as good,
    SUM(CASE WHEN hyl_egpa10 >= 2.0 AND hyl_egpa10 < 3.0 THEN 1 ELSE 0 END) as average,
    SUM(CASE WHEN hyl_egpa10 >= 1.0 AND hyl_egpa10 < 2.0 THEN 1 ELSE 0 END) as pass,
    SUM(CASE WHEN hyl_egpa10 < 1.0 THEN 1 ELSE 0 END) as fail
FROM huyl_enroll10 
WHERE hyl_tcno10 = ? AND hyl_escore10 IS NOT NULL
```

## 使用方式

### 1. 自动GPA计算
当更新学生成绩时，系统会自动计算对应的GPA：
```java
// 更新成绩和GPA
enrollmentService.updateScoreAndGPA(studentId, teachingClassId, score);
```

### 2. 批量更新GPA
管理员可以批量更新所有学生的GPA：
```java
// 批量更新所有GPA
enrollmentService.batchUpdateAllGPA();
```

### 3. 获取学生GPA信息
```java
// 获取学生加权GPA
BigDecimal weightedGPA = enrollmentService.getStudentWeightedGPA(studentId);

// 获取学生GPA排名
Integer rank = enrollmentService.getStudentGPARank(studentId);

// 获取学生GPA等级
String grade = enrollmentService.getStudentGPAGrade(studentId);
```

### 4. 获取课程GPA统计
```java
// 获取课程平均GPA
BigDecimal avgGPA = enrollmentService.getCourseAverageGPA(teachingClassId);

// 获取GPA分布
Map<String, Integer> distribution = enrollmentService.getGPADistribution(teachingClassId);
```

## 文件修改清单

### 新增文件
1. `src/main/java/org/example/demo111/util/GPAConverter.java` - GPA转换工具类
2. `src/main/java/org/example/demo111/controller/GPAController.java` - GPA管理控制器
3. `GPA_CONVERSION_GUIDE.md` - GPA转换标准说明文档

### 修改文件
1. `src/main/java/org/example/demo111/dao/EnrollmentDAO.java` - 添加GPA相关数据库操作方法
2. `src/main/java/org/example/demo111/service/EnrollmentService.java` - 添加GPA相关业务逻辑方法

## 注意事项

1. GPA转换公式：分数>=60时，GPA=(分数-50)/10；分数<60时，GPA=0
2. GPA值保留一位小数
3. 加权GPA计算考虑了课程学分
4. 批量更新GPA操作需要管理员权限
5. GPA计算会自动处理空值情况
6. 建议定期执行批量GPA更新操作

## 扩展功能

1. **GPA趋势分析** - 分析学生GPA变化趋势
2. **GPA预警系统** - 对低GPA学生进行预警
3. **GPA排名系统** - 实现更详细的排名功能
4. **GPA报告生成** - 生成GPA统计报告
5. **GPA标准配置** - 支持动态配置GPA转换标准 