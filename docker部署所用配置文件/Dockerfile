# 基础镜像
FROM openjdk:8
# 设定时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# 拷贝jar包
COPY sky.jar /app.jar
# 入口
ENTRYPOINT ["java", "-jar", "/app.jar"]