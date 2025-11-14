# ---------- Стадия 1: установка зависимостей (build stage) ----------
FROM python:3.10-slim AS builder

# Рабочая директория внутри контейнера
WORKDIR /app

# Сначала копируем только requirements.txt, чтобы кешировать слой с зависимостями
COPY requirements.txt .

# Обновляем pip и ставим зависимости в отдельную папку /install
RUN pip install --upgrade pip \
    && pip install --prefix=/install -r requirements.txt


# ---------- Стадия 2: финальный образ (runtime stage) ----------
FROM python:3.10-slim

WORKDIR /app

# Копируем установленные библиотеки из builder-образа
COPY --from=builder /install /usr/local

# Копируем исходники приложения
COPY app.py ./

# Открываем порт, на котором работает Flask
EXPOSE 8000

# Команда запуска приложения
CMD ["python", "app.py"]
