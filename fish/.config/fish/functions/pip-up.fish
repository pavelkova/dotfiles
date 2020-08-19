function pip-up --description 'upgrade all pip packages'
    command pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U
end
