# Base image (lightweight)
FROM amazonlinux:2

# Install Apache (httpd)
RUN yum update -y && \
    yum install -y httpd && \
    yum clean all

# Create web directory
RUN mkdir -p /var/www/html

# Remove default files
RUN rm -rf /var/www/html/*

# Copy your project files (index.html)
COPY index.html /var/www/html/

# Expose port
EXPOSE 80

# Start Apache in foreground
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
