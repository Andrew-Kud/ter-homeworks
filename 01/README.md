### Задание 1

1. Изучите файл **.gitignore**. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?(логины,пароли,ключи,токены итд)
- personal.auto.tfvars

---

2. Выполните код проекта. Найдите  в state-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение.
- "result": "j1G6GrdpwGtlDwpQ",

---

3. Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла main.tf. Выполните команду terraform validate. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.
- on main.tf line 23, in resource "docker_image": │ 23: resource "docker_image"
Не указано имя ресурса.

- on main.tf line 28, in resource "docker_container" "1nginx": | 28: resource "docker_container" "1nginx"
Ошибка в имени, такого имени нет в предыдущих блоках.

- on main.tf line 30, in resource "docker_container" "nginx": | 30:   name  = "example_${random_password.random_string_FAKE.resulT}"
Неправильно указаны random_string_FAKE, _FAKE - лишнее. А так же resulT - result.
<img width="1582" height="1341" alt="2" src="https://github.com/user-attachments/assets/22211388-18cd-4cab-88d6-96ebb0116a47" />

---

4. Объясните своими словами, в чём может быть опасность применения ключа -auto-approve.
- Опасно: тераформ без чтения применит изменения. может удалить и пересобрать.
- Допустимо: повторное применение известных изменений, локальная разработка, ci/cd пайплайны.

---

5. Уничтожьте созданные ресурсы с помощью terraform. Убедитесь, что все ресурсы удалены. Приложите содержимое файла terraform.tfstate.
```
terraform destroy
```
<img width="1953" height="1434" alt="4" src="https://github.com/user-attachments/assets/f72f7d84-a44f-4e13-b940-622a619314c8" />

---

6. Объясните, почему при этом не был удалён docker-образ nginx:latest.
причина в `keep_locally = true`, этот параметр говорит тераформу не удаляться при `terraform destroy`, а остаётся в локальном кэше.

https://library.tf/providers/kreuzwerker/docker/latest/docs/resources/image
keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation.



---
---
---

### Задание 2

1. Создайте в облаке ВМ. Сделайте это через web-консоль, чтобы не слить по незнанию токен от облака в github(это тема следующей лекции). Если хотите - попробуйте сделать это через terraform, прочитав документацию yandex cloud. Используйте файл personal.auto.tfvars и гитигнор или иной, безопасный способ передачи токена!
```
yc compute instance create \
  --name vm-2 \
  --zone ru-central1-b \
  --platform standard-v3 \
  --network-interface subnet-name=swarm-subnet,nat-ip-version=ipv4 \
  --preemptible \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2404-lts,type=network-hdd,size=10GB \
  --cores=2 --memory=4GB --core-fraction=20 \
  --ssh-key ~/.ssh/id_rsa.pub
```

---

2. Подключитесь к ВМ по ssh и установите стек docker.
```
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
newgrp docker
```

---

3. Найдите в документации docker provider способ настроить подключение terraform на вашей рабочей станции к remote docker context вашей ВМ через ssh.
```
docker context create yc-vm --docker "host=ssh://yc-user@158.160.14.41"
```
```
docker context ls
```
```
docker context use yc-vm
```

---

4. Используя terraform и remote docker context, скачайте и запустите на вашей ВМ контейнер mysql:8 на порту 127.0.0.1:3306, передайте ENV-переменные. Сгенерируйте разные пароли через random_password и передайте их в контейнер, используя интерполяцию из примера с nginx.(name  = "example_${random_password.random_string.result}" , двойные кавычки и фигурные скобки обязательны!)
- Код в директории "terraform-docker-mysql".
```
terraform init
```
```
terraform validate
```
```
terraform plan
```
```
terraform apply
```
`yes`

---

5. Зайдите на вашу ВМ , подключитесь к контейнеру и проверьте наличие секретных env-переменных с помощью команды env. Запишите ваш финальный код в репозиторий.
```
docker ps
```
```
docker exec -it 211654eb0c4d env | grep MYSQL
```
<img width="1634" height="1439" alt="5" src="https://github.com/user-attachments/assets/0c7acf30-c067-483f-8d99-beb7366a3be7" />


---
---
---
