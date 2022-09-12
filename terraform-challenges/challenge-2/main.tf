resource "docker_image" "php-httpd-image" {
    name = "php-httpd:challenge"
    build {
        path = "lamp_stack/php_httpd"
        label = {
            challenge : "second"
        }
    }
}

resource "docker_image" "mariadb-image" {
    name = "mariadb:challenge"
    build {
        path = "lamp_stack/custom_db"
        label = {
            challenge : "second"
        }
    }
}

resource "docker_network" "private_network" {
    name = "my_network"
    check_duplicate = true
    attachable = true
    labels {
        label = "challenge"
        value = "second"
    }
}

resource "docker_container" "php-httpd" {
    depends_on = [docker_network.private_network,docker_image.php-httpd-image]
    name = "webserver"
    hostname = "php-httpd"
    image = "php-httpd:challenge"
    networks = [docker_network.private_network.id] 
    ports {
        internal = "80"
        external = "80"
        ip = "0.0.0.0"
    }
    labels {
        label = "challenge"
        value = "second"
    }
    volumes {
        container_path  = "/var/www/html"
        host_path = "/root/code/terraform-challenges/challenge2/lamp_stack/website_content/"
    }
}

resource "docker_container" "phpmyadmin" {
    depends_on = [docker_network.private_network, docker_container.mariadb,docker_image.mariadb-image]
    name = "db_dashboard"
    hostname = "phpmyadmin"
    image = "phpmyadmin/phpmyadmin"
    networks_advanced {
         name = docker_network.private_network.name
    }
    links = ["db"]
    ports {
        internal = "80"
        external = "8081"
        ip = "0.0.0.0"
    }
    labels {
        label = "challenge"
        value = "second"
    }
}

resource "docker_container" "mariadb" {
    depends_on = [docker_network.private_network,docker_image.mariadb-image,docker_volume.mariadb_volume]
    name = "db"
    hostname = "db"
    image = "mariadb:challenge"
    networks = [docker_network.private_network.id] 
    ports {
        internal = "3306"
        external = "3306"
        ip = "0.0.0.0"
    }
    env = ["MYSQL_ROOT_PASSWORD=1234","MYSQL_DATABASE=simple-website"]
    volumes {
        volume_name = "mariadb-volume"
        container_path = "/var/lib/mysql"
    }
    labels {
        label = "challenge"
        value = "second"
    }
}

resource "docker_volume" "mariadb_volume" {
    name = "mariadb-volume"
}