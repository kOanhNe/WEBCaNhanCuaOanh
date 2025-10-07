# --- GIAI ĐOẠN 1: BUILD MAVEN (BUILDER) ---
# Dùng một image có sẵn Maven và JDK để build ra file .war
FROM maven:3.8-jdk-11 AS builder

# Tạo thư mục làm việc
WORKDIR /app

# Copy file pom.xml và tải dependencies về trước để tận dụng cache của Docker
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy toàn bộ source code còn lại
COPY src ./src

# Chạy lệnh build của Maven để tạo ra file .war
# Bỏ qua test để build nhanh hơn, bạn có thể bỏ -DskipTests nếu cần
RUN mvn package -DskipTests


# --- GIAI ĐOẠN 2: TẠO IMAGE TOMCAT CUỐI CÙNG (FINAL) ---
# Dùng image Tomcat gốc của bạn
FROM tomcat:9.0-jdk11

# Xóa các ứng dụng mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file .war đã được build ở GIAI ĐOẠN 1 vào thư mục webapps của Tomcat
# --from=builder chỉ định lấy file từ giai đoạn "builder" ở trên
COPY --from=builder /app/target/personal-website.war /usr/local/tomcat/webapps/ROOT.war

# Mở cổng 8080
EXPOSE 8080

# Khởi chạy Tomcat
CMD ["catalina.sh", "run"]
