VENV		= venv
ACTIVATE	= . ./${VENV}/bin/activate
ARGS		= --varsfile test/testvars.yml --varsfile test/testvars2.yml test/testtemplate.j2

.PHONY: usage
usage:
	@echo "run              run script used test files"
	@echo "run ARGS=...     run script used ARGS"
	@echo "build            build venv directory"
	@echo "clean            clean venv directory and files"
	@echo "lint             run lint use flake8"
	@echo "test             run test script"

.PHONY: run
run: activate
	${ACTIVATE} && pyrender/pyrender.py ${ARGS}

activate: ${VENV}
	@ln -s -v ./${VENV}/bin/activate

${VENV}: requirements.txt
	python3 -m venv ${VENV}
	${ACTIVATE} && pip install --upgrade pip setuptools wheel
	${ACTIVATE} && pip install --upgrade -r requirements.txt

.PHONY: clean
clean:
	rm -rf ${VENV}
	rm -rf activate
	rm -rf build dist pyrender.egg-info

.PHONY: lint
lint: activate
	@${ACTIVATE} && flake8 pyrender/*.py || :
	${ACTIVATE} && python setup.py flake8

.PHONY: test
test: activate
	@${ACTIVATE} && test/command_test.sh
	${ACTIVATE} && python setup.py check
