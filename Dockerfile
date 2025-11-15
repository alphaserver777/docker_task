# syntax=docker/dockerfile:1.4

# ---------- Стадия 1: сборка зависимостей (Builder) ----------
FROM python:3.10-slim AS builder

WORKDIR /app

# (опционально) инструменты для сборки (нужны, если какие-то пакеты требуют компиляции)
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

# Копируем список зависимостей
COPY requirements.txt .

# 1) Сборка wheel-пакетов с использованием кеша pip
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --upgrade pip && \
    pip wheel -r requirements.txt -w /wheels

# 2) Установка зависимостей из локальных wheel-пакетов
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --prefix=/install --no-index --find-links=/wheels -r requirements.txt


# ---------- Стадия 2: финальный образ (Runtime) ----------
FROM python:3.10-slim

WORKDIR /app

# Копируем установленные зависимости из builder-образа
COPY --from=builder /install /usr/local

# Копируем исходники приложения
COPY app.py .

# Открываем порт приложения
EXPOSE 8000

# Команда запуска
CMD ["python", "app.py"]
