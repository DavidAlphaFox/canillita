PROJECT = canillita

CONFIG ?= test/test.config

DEPS = shotgun sumo_rest lasse katana swagger sumo_db trails lager
SHELL_DEPS = sync
TEST_DEPS = shotgun mixer
LOCAL_DEPS = tools compiler syntax_tools common_test inets test_server
LOCAL_DEPS += dialyzer wx

dep_sumo_rest = git https://github.com/inaka/sumo_rest.git davecaos.cowboy2x
dep_lasse = git https://github.com/inaka/lasse.git davecaos.cowboy2x
dep_sync = git https://github.com/rustyio/sync.git 9c78e7b
dep_katana = git https://github.com/inaka/erlang-katana.git 07efe94
dep_shotgun = git https://github.com/inaka/shotgun.git dave.151.update.deps.to.2.0.0.pre
dep_mixer = git https://github.com/inaka/mixer.git 0.1.4
dep_swagger = git https://github.com/inaka/cowboy-swagger.git 0.1.0
dep_sumo_db = git https://github.com/inaka/sumo_db.git f8a3689
dep_trails = git https://github.com/inaka/cowboy-trails.git 0.1.0
dep_lager = git https://github.com/basho/lager.git 3.0.2

include erlang.mk

DIALYZER_DIRS := ebin/ test/
DIALYZER_OPTS := --verbose --statistics -Wunmatched_returns

ERLC_OPTS := +debug_info +'{parse_transform, lager_transform}'
TEST_ERLC_OPTS += +debug_info +'{parse_transform, lager_transform}'
CT_OPTS = -cover test/canillita.coverspec -erl_args -config ${CONFIG}

SHELL_OPTS = -s sync -config ${CONFIG}

quicktests: app
	@$(MAKE) --no-print-directory app-build test-dir ERLC_OPTS="$(TEST_ERLC_OPTS)"
	$(verbose) mkdir -p $(CURDIR)/logs/
	$(gen_verbose) $(CT_RUN) -suite $(addsuffix _SUITE,$(CT_SUITES)) $(CT_OPTS)

test-build-plt: ERLC_OPTS=$(TEST_ERLC_OPTS)
test-build-plt:
	@$(MAKE) --no-print-directory test-dir ERLC_OPTS="$(TEST_ERLC_OPTS)"
	$(gen_verbose) touch ebin/test

plt-all: PLT_APPS := $(ALL_TEST_DEPS_DIRS)
plt-all: test-deps test-build-plt plt

dialyze-all: app test-build-plt dialyze
