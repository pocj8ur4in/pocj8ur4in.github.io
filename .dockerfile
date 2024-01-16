# 기본 이미지: Ruby와 Node.js를 설치한 이미지 사용
FROM ruby:3.1.2

# 필요한 시스템 도구 및 라이브러리 설치
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs

# Jekyll과 Bundler 설치
RUN gem install jekyll bundler

# 작업 디렉토리 생성
WORKDIR /app

# 소스 코드 복사
COPY . /app

# Gemfile.lock 복사
COPY Gemfile Gemfile.lock ./

# 종속성 설치
RUN bundle install

# Jekyll 서버 실행
CMD ["bundle", "exec", "jekyll", "serve", "--host=0.0.0.0"]

# 블로그 실행시키기 위한 포트 노출
EXPOSE 4000