# Student Management Information System (SMIS)

A comprehensive web-based Student Management Information System built with Jakarta EE, featuring user authentication, student management, course management, and enrollment tracking.

## Features

### Core Functionality
- **User Authentication**: Secure login/logout with session management
- **Student Management**: Add, edit, delete, and view student records
- **Course Management**: Manage courses with capacity tracking
- **Enrollment System**: Enroll students in courses with grade management
- **REST API**: External API access for mobile applications
- **Responsive Design**: Bootstrap 5 responsive UI

### Technical Features
- **Jakarta EE**: Modern Java enterprise framework
- **JPA/Hibernate**: Database persistence with entity relationships
- **Servlets**: Request handling and session management
- **JSP/JSTL**: Dynamic web pages with server-side rendering
- **H2 Database**: In-memory database for development
- **RESTful API**: JSON endpoints for external integration

## Technology Stack

- **Backend**: Jakarta EE 10, Servlets, JPA (EclipseLink), MicroProfile
- **Frontend**: JSP, JSTL, Bootstrap 5, HTML5
- **Database**: H2 (development), MySQL (production/Docker)
- **Build Tool**: Maven
- **Container**: Docker & Docker Compose
- **Server**: Apache Tomee Plume 10.1.2 (Recommended)
- **Java**: JDK 17 (Required)
- **JPA Provider**: EclipseLink (Tomee's default)

## Prerequisites

- Java 17 or higher
- Maven 3.6+
- Jakarta EE compatible application server
- **Optional for MySQL**: Docker and Docker Compose

## Project Structure

```
src/
├── main/
│   ├── java/
│   │   └── com/jakartaproject/
│   │       ├── entity/          # JPA Entities
│   │       │   ├── User.java
│   │       │   ├── Student.java
│   │       │   ├── Course.java
│   │       │   └── Enrollment.java
│   │       ├── service/         # Business Logic
│   │       │   ├── UserService.java
│   │       │   ├── StudentService.java
│   │       │   ├── CourseService.java
│   │       │   └── EnrollmentService.java
│   │       ├── servlet/         # Servlet Controllers
│   │       │   ├── LoginServlet.java
│   │       │   ├── LogoutServlet.java
│   │       │   ├── StudentServlet.java
│   │       │   ├── CourseServlet.java
│   │       │   ├── EnrollmentServlet.java
│   │       │   └── DataInitializerServlet.java
│   │       └── rest/            # REST API Resources
│   │           ├── StudentResource.java
│   │           ├── CourseResource.java
│   │           └── EnrollmentResource.java
│   ├── resources/
│   │   └── META-INF/
│   │       ├── persistence.xml
│   │       └── beans.xml
│   └── webapp/
│       ├── WEB-INF/
│       │   ├── web.xml
│       │   └── faces-config.xml
│       └── *.jsp               # JSP Pages
└── test/
    └── java/
```

## Setup Instructions

### 1. Clone and Build

```bash
git clone <repository-url>
cd JakartaProject
mvn clean install
```

### 2. Deploy to Application Server

#### Option A: Using Maven with Cargo Plugin (Recommended)

Add to your `pom.xml`:

```xml
<plugin>
    <groupId>org.codehaus.cargo</groupId>
    <artifactId>cargo-maven2-plugin</artifactId>
    <version>1.10.5</version>
    <configuration>
        <container>
            <containerId>tomcat10x</containerId>
            <type>embedded</type>
        </container>
    </configuration>
</plugin>
```

Then run:
```bash
mvn cargo:run
```

#### Option B: Manual Deployment

1. Build the WAR file:
```bash
mvn clean package
```

2. Deploy `target/JakartaProject-1.0-SNAPSHOT.war` to your application server

#### Option C: Tomee Plume 10.1.2 (Recommended)

1. **Download and Install Tomee Plume:**
   - Download from: https://tomee.apache.org/download-ng.html
   - Choose: `Apache Tomee 10.1.2 Plume`
   - Extract to: `C:\Program Files\apache-tomee-10.1.2-plume\apache-tomee-plume-10.1.2`

2. **Start Tomee:**
   ```bash
   cd "C:\Program Files\apache-tomee-10.1.2-plume\apache-tomee-plume-10.1.2\bin"
   catalina.bat run
   ```

3. **Deploy Application:**
   - Use IntelliJ IDEA's Tomcat integration (recommended), OR
   - Copy WAR manually: `mvn clean package && copy target\JakartaProject-1.0-SNAPSHOT.war "C:\Program Files\apache-tomee-10.1.2-plume\apache-tomee-plume-10.1.2\webapps\"`

4. **Test Deployment:**
   ```
   ```

5. **Access Application:**
   - URL: `http://localhost:8080/JakartaProject/`
   - Initialize data: `http://localhost:8080/JakartaProject/init-data`

### 3. Initialize Sample Data

After deployment, initialize sample data by visiting:
```
http://localhost:8080/JakartaProject/init-data
```

This will create:
- Admin user: `admin` / `admin123`
- Student user: `student` / `student123`
- Sample students and courses

## MySQL Docker Setup

### Option 1: Quick Start with Docker Compose

1. **Start MySQL Database:**

   # Or manually with docker-compose
   docker-compose up -d mysql

2. **Build and run the application with MySQL:**
   ```bash
   # Build with MySQL profile
   mvn clean package -Pmysql

   # Deploy the generated WAR file to your application server
   ```

3. **Access phpMyAdmin (optional):**
   - URL: `http://localhost:8081`
   - Username: `smis_user`
   - Password: `smis_password`

4. **Stop MySQL Database:**
   ```bash
   # Or manually
   docker-compose down
   ```

### Option 2: Manual MySQL Setup

If you have MySQL installed locally or running elsewhere:

1. **Create database and user:**
   ```sql
   CREATE DATABASE smis CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   CREATE USER 'smis_user'@'localhost' IDENTIFIED BY 'smis_password';
   GRANT ALL PRIVILEGES ON smis.* TO 'smis_user'@'localhost';
   FLUSH PRIVILEGES;
   ```

2. **Update application configuration:**
   - Set environment variables or system properties:
     ```bash
     export DB_URL="jdbc:mysql://localhost:3306/smis?useSSL=false&serverTimezone=UTC"
     export DB_USERNAME="smis_user"
     export DB_PASSWORD="smis_password"
     ```

### Database Configuration

The application supports multiple database configurations through Maven profiles:

- **H2 (Default)**: In-memory database for quick development
  ```bash
  mvn clean package  # Uses H2
  ```

- **MySQL**: Persistent database for production
  ```bash
  mvn clean package -Pmysql  # Uses MySQL
  ```

### Environment Variables

You can override database settings using system properties:

```bash
# H2 (default)
mvn clean package

# MySQL with custom settings
mvn clean package -Pmysql \
  -Ddb.url="jdbc:mysql://your-host:3306/your-db" \
  -Ddb.username="your-user" \
  -Ddb.password="your-password"
```

## Usage

### Login

Access the application at: `http://localhost:8080/JakartaProject/`

**Default Credentials:**
- **Admin**: username: `admin`, password: `admin123`
- **Student**: username: `student`, password: `student123`

### Navigation

#### Admin Features
- **Dashboard**: Overview with statistics and quick actions
- **Students**: Add, edit, delete, and view student records
- **Courses**: Manage courses with capacity tracking
- **Enrollments**: View enrollments and assign grades

#### Student Features
- **Dashboard**: Personal overview
- **My Courses**: View enrolled courses and grades

### REST API

The system provides REST API endpoints for external integration:

#### Students
- `GET /api/students` - Get all students
- `GET /api/students/{id}` - Get student by ID
- `POST /api/students` - Create new student

#### Courses
- `GET /api/courses` - Get all courses
- `GET /api/courses/{id}` - Get course by ID
- `POST /api/courses` - Create new course

#### Enrollments
- `POST /api/enrollments` - Enroll student in course
  ```json
  {
    "studentId": 1,
    "courseId": 2
  }
  ```

### API Usage Example

```bash
# Get all students
curl -X GET http://localhost:8080/JakartaProject/api/students

# Create a new student
curl -X POST http://localhost:8080/JakartaProject/api/students \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Alice Wilson",
    "email": "alice.wilson@university.edu",
    "enrollmentDate": "2024-01-15",
    "major": "Computer Science"
  }'
```

## Configuration

### Database Configuration

The application supports multiple database configurations through Maven profiles:

#### H2 (Default - Development)
- **Type**: In-memory database
- **Use case**: Quick development and testing
- **Command**: `mvn clean package` (default profile)
- **Data persistence**: Lost on application restart

#### MySQL (Production)
- **Type**: Persistent relational database
- **Use case**: Production deployment with Docker
- **Command**: `mvn clean package -Pmysql`
- **Data persistence**: Survives application restarts

**MySQL Connection Details (Docker):**
- Host: `localhost:3308`
- Database: `smis`
- Username: `smis_user`
- Password: `smis_password`

For custom database configurations, modify `src/main/resources/META-INF/persistence.xml`:

```xml
<properties>
    <property name="jakarta.persistence.jdbc.driver" value="com.mysql.cj.jdbc.Driver"/>
    <property name="jakarta.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/smis?useSSL=false&amp;serverTimezone=UTC&amp;allowPublicKeyRetrieval=true"/>
    <property name="jakarta.persistence.jdbc.user" value="your_username"/>
    <property name="jakarta.persistence.jdbc.password" value="your_password"/>
    <property name="hibernate.dialect" value="org.hibernate.dialect.MySQLDialect"/>
</properties>
```

### Session Configuration

Session timeout is configured in `web.xml` (currently 30 minutes). Modify as needed:

```xml
<session-config>
    <session-timeout>30</session-timeout> <!-- minutes -->
</session-config>
```

## Security Features

- **Session Management**: Automatic session timeout after 30 minutes
- **Authentication**: Username/password based authentication
- **Role-based Access**: Admin and Student roles with different permissions
- **Input Validation**: Server-side validation for all forms
- **SQL Injection Protection**: JPA prevents SQL injection attacks

## Development

### Running Tests

```bash
mvn test
```

### Code Formatting

```bash
mvn formatter:format
```

### Adding New Features

1. Create entity classes in `entity` package
2. Add service methods in `service` package
3. Create servlets in `servlet` package
4. Add JSP pages in `webapp` directory
5. Update REST resources if needed

## Production Deployment

### Database Migration

For production, consider:
- PostgreSQL or MySQL for persistent storage
- Database connection pooling
- Environment-specific configuration

### Security Enhancements

- HTTPS configuration
- Password hashing (currently using plain text for demo)
- CSRF protection
- Rate limiting

### Performance Optimization

- Database indexing
- Caching implementation
- CDN for static resources

## Troubleshooting

### Common Issues

1. **Port Conflicts**: Change server port in application server configuration
2. **Database Connection**: Verify database credentials in `persistence.xml`
3. **Memory Issues**: Increase JVM heap size for large datasets
4. **Session Timeout**: Check session configuration in `web.xml`

#### Docker MySQL Issues

1. **Container Won't Start**:
   ```bash
   # Check container logs
   docker-compose logs mysql

   # Remove and restart
   docker-compose down -v
   docker-compose up -d mysql
   ```

2. **Connection Refused**:
   - Ensure MySQL container is healthy: `docker-compose ps`
   - Wait for health check to pass (may take 30-60 seconds)
   - Verify port 3306 is not in use: `netstat -an | find "3306"`

3. **Access Denied**:
   - Check credentials match `docker-compose.yml`
   - Use phpMyAdmin at `http://localhost:8081` to verify

4. **Data Persistence**:
   - Data is stored in Docker volume `mysql_data`
   - To reset database: `docker-compose down -v` then restart

### Logs

Application logs are available in the application server logs directory.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes with tests
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Check the troubleshooting section
- Review the API documentation

---

**Note**: This is an educational project demonstrating Jakarta EE concepts. For production use, implement additional security measures and conduct thorough testing.
