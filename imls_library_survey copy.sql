-- The database is created to analyze library survey trend over 6 years in the United States.
-- The data set is gotten from the Institue for Museum and Library Services (IMLS).
-- Data set: FY 2016 and FY 2010
-- DATA SOURCE: https://www.imls.gov/research-evaluation/data-collection/public-libraries-survey
-- DOCUMENTATION: https://www.imls.gov/sites/default/files/fy2016_pls_data_file_documentation.pdf
-- SQL VERSION: PostgreSQL 12

-- Table: public.imls_library_survey_2016

-- DROP TABLE public.imls_library_survey_2016;

CREATE TABLE public.imls_library_survey_2016
(
    stabr character varying(2) COLLATE pg_catalog."default" NOT NULL,
    fscskey character varying(6) COLLATE pg_catalog."default" NOT NULL,
    libid character varying(20) COLLATE pg_catalog."default" NOT NULL,
    libname character varying(70) COLLATE pg_catalog."default" NOT NULL,
    address character varying(40) COLLATE pg_catalog."default" NOT NULL,
    city character varying(20) COLLATE pg_catalog."default" NOT NULL,
    zip character varying(5) COLLATE pg_catalog."default" NOT NULL,
    zip4 character varying(4) COLLATE pg_catalog."default" NOT NULL,
    address_m character varying(40) COLLATE pg_catalog."default" NOT NULL,
    city_m character varying(20) COLLATE pg_catalog."default" NOT NULL,
    zip_m character varying(5) COLLATE pg_catalog."default" NOT NULL,
    zip4_m character varying(4) COLLATE pg_catalog."default" NOT NULL,
    cnty character varying(30) COLLATE pg_catalog."default" NOT NULL,
    phone character varying(10) COLLATE pg_catalog."default" NOT NULL,
    c_relatin character varying(2) COLLATE pg_catalog."default" NOT NULL,
    c_legbas character varying(2) COLLATE pg_catalog."default" NOT NULL,
    c_admin character varying(2) COLLATE pg_catalog."default" NOT NULL,
    c_fscs character varying(1) COLLATE pg_catalog."default" NOT NULL,
    geocode character varying(3) COLLATE pg_catalog."default" NOT NULL,
    lsabound character varying(1) COLLATE pg_catalog."default" NOT NULL,
    startdat character varying(10) COLLATE pg_catalog."default" NOT NULL,
    enddate character varying(10) COLLATE pg_catalog."default" NOT NULL,
    popu_lsa integer NOT NULL,
    f_poplsa character varying(4) COLLATE pg_catalog."default" NOT NULL,
    popu_und integer NOT NULL,
    centlib smallint NOT NULL,
    f_cenlib character varying(4) COLLATE pg_catalog."default" NOT NULL,
    branlib smallint NOT NULL,
    f_brlib character varying(4) COLLATE pg_catalog."default" NOT NULL,
    bkmob smallint NOT NULL,
    f_bkmob character varying(4) COLLATE pg_catalog."default" NOT NULL,
    master numeric(7,2) NOT NULL,
    f_master character varying(4) COLLATE pg_catalog."default" NOT NULL,
    libraria numeric(7,2) NOT NULL,
    f_librar character varying(4) COLLATE pg_catalog."default" NOT NULL,
    othpaid numeric(7,2) NOT NULL,
    f_othstf character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    f_totstf character varying(4) COLLATE pg_catalog."default" NOT NULL,
    locgvt integer NOT NULL,
    f_locgvt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    stgvt integer NOT NULL,
    f_stgvt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    fedgvt integer NOT NULL,
    f_fedgvt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    othincm integer NOT NULL,
    f_othinc character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totincm integer NOT NULL,
    f_totinc character varying(4) COLLATE pg_catalog."default" NOT NULL,
    salaries integer,
    f_salx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    benefit integer,
    f_benx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    staffexp integer,
    f_tostfx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    prmatexp integer NOT NULL,
    f_prmatx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    elmatexp integer NOT NULL,
    f_elmatx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    othmatex integer NOT NULL,
    f_otmatx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totexpco integer NOT NULL,
    f_tocolx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    othopexp integer,
    f_othopx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totopexp integer NOT NULL,
    f_totopx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    lcap_rev integer NOT NULL,
    f_lcaprv character varying(4) COLLATE pg_catalog."default" NOT NULL,
    scap_rev integer NOT NULL,
    f_scaprv character varying COLLATE pg_catalog."default" NOT NULL,
    fcap_rev integer NOT NULL,
    f_fcaprv character varying(4) COLLATE pg_catalog."default" NOT NULL,
    ocap_rev integer NOT NULL,
    f_ocaprv character varying COLLATE pg_catalog."default" NOT NULL,
    cap_rev integer NOT NULL,
    f_tcaprv character varying COLLATE pg_catalog."default" NOT NULL,
    capital integer NOT NULL,
    f_tcapx character varying COLLATE pg_catalog."default" NOT NULL,
    bkvol integer NOT NULL,
    ebook integer NOT NULL,
    audio_ph integer NOT NULL,
    f_aud_ph character varying(4) COLLATE pg_catalog."default" NOT NULL,
    audio_dl integer NOT NULL,
    video_ph integer NOT NULL,
    f_vid_ph character varying(4) COLLATE pg_catalog."default" NOT NULL,
    video_dl integer NOT NULL,
    ec_lo_ot integer NOT NULL,
    ec_st integer NOT NULL,
    eleccoll integer NOT NULL,
    subscrip integer NOT NULL,
    f_prsub character varying(4) COLLATE pg_catalog."default" NOT NULL,
    hrs_open integer NOT NULL,
    f_hrs_op character varying(4) COLLATE pg_catalog."default" NOT NULL,
    visits integer NOT NULL,
    f_visits character varying(4) COLLATE pg_catalog."default" NOT NULL,
    referenc integer NOT NULL,
    f_refer character varying(4) COLLATE pg_catalog."default" NOT NULL,
    regbor integer NOT NULL,
    f_regbor character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totcir integer NOT NULL,
    kidcircl integer NOT NULL,
    f_kidcir character varying COLLATE pg_catalog."default" NOT NULL,
    elmatcir integer NOT NULL,
    physcir integer NOT NULL,
    elinfo integer NOT NULL,
    elcont integer NOT NULL,
    totcol integer NOT NULL,
    loanto integer NOT NULL,
    f_loanto character varying(4) COLLATE pg_catalog."default" NOT NULL,
    loanfm integer NOT NULL,
    f_loanfm character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totpro integer NOT NULL,
    f_totpro character varying(4) COLLATE pg_catalog."default" NOT NULL,
    kidpro integer NOT NULL,
    f_kidpro character varying(4) COLLATE pg_catalog."default" NOT NULL,
    yapro integer NOT NULL,
    f_yapro character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totatten integer NOT NULL,
    f_totatt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    kidatten integer NOT NULL,
    f_kidatt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    yaatten integer NOT NULL,
    f_yaatt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    gpterms integer NOT NULL,
    f_gpterm character varying(4) COLLATE pg_catalog."default" NOT NULL,
    pitusr integer NOT NULL,
    f_pitusr character varying(4) COLLATE pg_catalog."default" NOT NULL,
    wifises integer NOT NULL,
    yr_sub integer NOT NULL,
    obereg character varying(2) COLLATE pg_catalog."default" NOT NULL,
    rstatus integer NOT NULL,
    statstru character varying(2) COLLATE pg_catalog."default" NOT NULL,
    statname character varying(2) COLLATE pg_catalog."default" NOT NULL,
    stataddr character varying(2) COLLATE pg_catalog."default" NOT NULL,
    longitud numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL,
    incitsst character varying(2) COLLATE pg_catalog."default" NOT NULL,
    incitsco character varying(3) COLLATE pg_catalog."default" NOT NULL,
    gnisplac character varying(5) COLLATE pg_catalog."default" NOT NULL,
    cntypop integer NOT NULL,
    locale character varying(2) COLLATE pg_catalog."default" NOT NULL,
    locale_mod character varying(2) COLLATE pg_catalog."default" NOT NULL,
    reaplocale character varying(2) COLLATE pg_catalog."default" NOT NULL,
    reaplocale_mod character varying(2) COLLATE pg_catalog."default" NOT NULL,
    centract numeric(7,2) NOT NULL,
    cenblock character varying(4) COLLATE pg_catalog."default" NOT NULL,
    cdcode character varying(4) COLLATE pg_catalog."default" NOT NULL,
    cbsa integer NOT NULL,
    microf character varying(2) COLLATE pg_catalog."default" NOT NULL,
    addrtype character varying(20) COLLATE pg_catalog."default" NOT NULL,
    mstatus character varying(2) COLLATE pg_catalog."default" NOT NULL,
    score numeric(5,2) NOT NULL,
    CONSTRAINT fscskey2016_key PRIMARY KEY (fscskey)
)

TABLESPACE pg_default;

ALTER TABLE public.imls_library_survey_2016
    OWNER to postgres;
-- Index: city2016_idx

-- DROP INDEX public.city2016_idx;

CREATE INDEX city2016_idx
    ON public.imls_library_survey_2016 USING btree
    (city COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: libname2016_idx

-- DROP INDEX public.libname2016_idx;

CREATE INDEX libname2016_idx
    ON public.imls_library_survey_2016 USING btree
    (libname COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: stabr2016_idx

-- DROP INDEX public.stabr2016_idx;

CREATE INDEX stabr2016_idx
    ON public.imls_library_survey_2016 USING btree
    (stabr COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: visits2016_idx

-- DROP INDEX public.visits2016_idx;

CREATE INDEX visits2016_idx
    ON public.imls_library_survey_2016 USING btree
    (visits ASC NULLS LAST)
    TABLESPACE pg_default;
-- Table: public.imls_library_survey_2010

-- DROP TABLE public.imls_library_survey_2010;

CREATE TABLE public.imls_library_survey_2010
(
    stabr character varying(2) COLLATE pg_catalog."default" NOT NULL,
    fscskey character varying(6) COLLATE pg_catalog."default" NOT NULL,
    libid character varying(20) COLLATE pg_catalog."default" NOT NULL,
    libname character varying(70) COLLATE pg_catalog."default" NOT NULL,
    address character varying(40) COLLATE pg_catalog."default" NOT NULL,
    city character varying(20) COLLATE pg_catalog."default" NOT NULL,
    zip character varying(5) COLLATE pg_catalog."default" NOT NULL,
    zip4 character varying(4) COLLATE pg_catalog."default" NOT NULL,
    address_m character varying(40) COLLATE pg_catalog."default" NOT NULL,
    city_m character varying(20) COLLATE pg_catalog."default" NOT NULL,
    zip_m character varying(5) COLLATE pg_catalog."default" NOT NULL,
    zip4_m character varying(4) COLLATE pg_catalog."default" NOT NULL,
    cnty character varying(30) COLLATE pg_catalog."default" NOT NULL,
    phone character varying(10) COLLATE pg_catalog."default" NOT NULL,
    web_addr character varying(100) COLLATE pg_catalog."default",
    c_relatin character varying(2) COLLATE pg_catalog."default" NOT NULL,
    c_legbas character varying(2) COLLATE pg_catalog."default" NOT NULL,
    c_admin character varying(2) COLLATE pg_catalog."default" NOT NULL,
    c_fscs character varying(1) COLLATE pg_catalog."default" NOT NULL,
    geocode character varying(3) COLLATE pg_catalog."default" NOT NULL,
    lsabound character varying(1) COLLATE pg_catalog."default" NOT NULL,
    startdat character varying(10) COLLATE pg_catalog."default" NOT NULL,
    f_stdat character varying(4) COLLATE pg_catalog."default" NOT NULL,
    enddate character varying(10) COLLATE pg_catalog."default" NOT NULL,
    f_endat character varying(4) COLLATE pg_catalog."default" NOT NULL,
    popu_lsa integer NOT NULL,
    f_poplsa character varying(4) COLLATE pg_catalog."default" NOT NULL,
    popu_und integer NOT NULL,
    f_popund character varying(4) COLLATE pg_catalog."default" NOT NULL,
    centlib smallint NOT NULL,
    f_cenlib character varying(4) COLLATE pg_catalog."default" NOT NULL,
    branlib smallint NOT NULL,
    f_brlib character varying(4) COLLATE pg_catalog."default" NOT NULL,
    bkmob smallint NOT NULL,
    f_bkmob character varying(4) COLLATE pg_catalog."default" NOT NULL,
    master numeric(7,2) NOT NULL,
    f_master character varying(4) COLLATE pg_catalog."default" NOT NULL,
    libraria numeric(7,2) NOT NULL,
    f_librar character varying(4) COLLATE pg_catalog."default" NOT NULL,
    othpaid numeric(7,2) NOT NULL,
    f_othstf character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    f_totstf character varying(4) COLLATE pg_catalog."default" NOT NULL,
    locgvt integer NOT NULL,
    f_locgvt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    stgvt integer NOT NULL,
    f_stgvt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    fedgvt integer NOT NULL,
    f_fedgvt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    othincm integer NOT NULL,
    f_othinc character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totincm integer NOT NULL,
    f_totinc character varying(4) COLLATE pg_catalog."default" NOT NULL,
    salaries integer,
    f_salx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    benefit integer,
    f_benx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    staffexp integer,
    f_tostfx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    prmatexp integer NOT NULL,
    f_prmatx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    elmatexp integer NOT NULL,
    f_elmatx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    othmatex integer NOT NULL,
    f_otmatx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totexpco integer NOT NULL,
    f_tocolx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    othopexp integer,
    f_othopx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totopexp integer NOT NULL,
    f_totopx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    lcap_rev integer NOT NULL,
    f_lcaprv character varying(4) COLLATE pg_catalog."default" NOT NULL,
    scap_rev integer NOT NULL,
    f_scaprv character varying COLLATE pg_catalog."default" NOT NULL,
    fcap_rev integer NOT NULL,
    f_fcaprv character varying COLLATE pg_catalog."default" NOT NULL,
    ocap_rev integer NOT NULL,
    f_ocaprv character varying COLLATE pg_catalog."default" NOT NULL,
    cap_rev integer NOT NULL,
    f_tcaprv character varying COLLATE pg_catalog."default" NOT NULL,
    capital integer NOT NULL,
    f_tcapx character varying COLLATE pg_catalog."default" NOT NULL,
    bkvol integer NOT NULL,
    f_bkvol character varying(4) COLLATE pg_catalog."default" NOT NULL,
    ebook integer NOT NULL,
    f_ebook character varying(4) COLLATE pg_catalog."default" NOT NULL,
    audio_ph integer NOT NULL,
    f_aud_ph character varying(4) COLLATE pg_catalog."default" NOT NULL,
    audio_dl integer NOT NULL,
    f_aud_dl character varying(4) COLLATE pg_catalog."default" NOT NULL,
    video_ph integer NOT NULL,
    f_vid_ph character varying(4) COLLATE pg_catalog."default" NOT NULL,
    video_dl integer NOT NULL,
    f_vid_dl character varying(4) COLLATE pg_catalog."default" NOT NULL,
    db_loc integer NOT NULL,
    f_db_loc character varying(4) COLLATE pg_catalog."default" NOT NULL,
    db_st integer NOT NULL,
    f_db_st character varying(4) COLLATE pg_catalog."default" NOT NULL,
    db_oth integer NOT NULL,
    f_db_oth character varying(4) COLLATE pg_catalog."default" NOT NULL,
    databases integer NOT NULL,
    f_dbase character varying(4) COLLATE pg_catalog."default" NOT NULL,
    subscrip integer NOT NULL,
    f_prsub character varying(4) COLLATE pg_catalog."default" NOT NULL,
    hrs_open integer NOT NULL,
    f_hrs_op character varying(4) COLLATE pg_catalog."default" NOT NULL,
    visits integer NOT NULL,
    f_visits character varying(4) COLLATE pg_catalog."default" NOT NULL,
    referenc integer NOT NULL,
    f_refer character varying(4) COLLATE pg_catalog."default" NOT NULL,
    regbor integer NOT NULL,
    f_regbor character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totcir integer NOT NULL,
    f_totcir character varying(4) COLLATE pg_catalog."default" NOT NULL,
    kidcircl integer NOT NULL,
    f_kidcir character varying COLLATE pg_catalog."default" NOT NULL,
    loanto integer NOT NULL,
    f_loanto character varying(4) COLLATE pg_catalog."default" NOT NULL,
    loanfm integer NOT NULL,
    f_loanfm character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totpro integer NOT NULL,
    f_totpro character varying(4) COLLATE pg_catalog."default" NOT NULL,
    kidpro integer NOT NULL,
    f_kidpro character varying(4) COLLATE pg_catalog."default" NOT NULL,
    yapro integer NOT NULL,
    f_yapro character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totatten integer NOT NULL,
    f_totatt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    kidatten integer NOT NULL,
    f_kidatt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    yaatten integer NOT NULL,
    f_yaatt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    gpterms integer NOT NULL,
    f_gpterm character varying(4) COLLATE pg_catalog."default" NOT NULL,
    pitusr integer NOT NULL,
    f_pitusr character varying(4) COLLATE pg_catalog."default" NOT NULL,
    yr_sub integer NOT NULL,
    obereg character varying(2) COLLATE pg_catalog."default" NOT NULL,
    rstatus integer NOT NULL,
    statstru character varying(2) COLLATE pg_catalog."default" NOT NULL,
    statname character varying(2) COLLATE pg_catalog."default" NOT NULL,
    stataddr character varying(2) COLLATE pg_catalog."default" NOT NULL,
    longitud numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL,
    fipsst character varying(2) COLLATE pg_catalog."default" NOT NULL,
    fipsco character varying(3) COLLATE pg_catalog."default" NOT NULL,
    fipsplac character varying(5) COLLATE pg_catalog."default" NOT NULL,
    cntypop integer NOT NULL,
    locale character varying(2) COLLATE pg_catalog."default" NOT NULL,
    centract numeric(7,2) NOT NULL,
    cenblock character varying(4) COLLATE pg_catalog."default" NOT NULL,
    cdcode character varying(4) COLLATE pg_catalog."default" NOT NULL,
    mat_cent character varying(2) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT fscskey2010_key PRIMARY KEY (fscskey)
)

TABLESPACE pg_default;

ALTER TABLE public.imls_library_survey_2010
    OWNER to postgres;
-- Index: city2010_idx

-- DROP INDEX public.city2010_idx;

CREATE INDEX city2010_idx
    ON public.imls_library_survey_2010 USING btree
    (city COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: libname2010_idx

-- DROP INDEX public.libname2010_idx;

CREATE INDEX libname2010_idx
    ON public.imls_library_survey_2010 USING btree
    (libname COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: stabr2010_idx

-- DROP INDEX public.stabr2010_idx;

CREATE INDEX stabr2010_idx
    ON public.imls_library_survey_2010 USING btree
    (stabr COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: visits2010_idx

-- DROP INDEX public.visits2010_idx;

CREATE INDEX visits2010_idx
    ON public.imls_library_survey_2010 USING btree
    (visits ASC NULLS LAST)
    TABLESPACE pg_default;

-- Table: public.imls_library_survey_2012

-- DROP TABLE public.imls_library_survey_2012;

CREATE TABLE public.imls_library_survey_2012
(
    stabr character varying(2) COLLATE pg_catalog."default" NOT NULL,
    fscskey character varying(6) COLLATE pg_catalog."default" NOT NULL,
    libid character varying(20) COLLATE pg_catalog."default" NOT NULL,
    libname character varying(70) COLLATE pg_catalog."default" NOT NULL,
    address character varying(40) COLLATE pg_catalog."default" NOT NULL,
    city character varying(20) COLLATE pg_catalog."default" NOT NULL,
    zip character varying(5) COLLATE pg_catalog."default" NOT NULL,
    zip4 character varying(4) COLLATE pg_catalog."default" NOT NULL,
    address_m character varying(40) COLLATE pg_catalog."default" NOT NULL,
    city_m character varying(20) COLLATE pg_catalog."default" NOT NULL,
    zip_m character varying(5) COLLATE pg_catalog."default" NOT NULL,
    zip4_m character varying(4) COLLATE pg_catalog."default" NOT NULL,
    cnty character varying(30) COLLATE pg_catalog."default" NOT NULL,
    phone character varying(10) COLLATE pg_catalog."default" NOT NULL,
    c_relatin character varying(2) COLLATE pg_catalog."default" NOT NULL,
    c_legbas character varying(2) COLLATE pg_catalog."default" NOT NULL,
    c_admin character varying(2) COLLATE pg_catalog."default" NOT NULL,
    c_fscs character varying(1) COLLATE pg_catalog."default" NOT NULL,
    geocode character varying(3) COLLATE pg_catalog."default" NOT NULL,
    lsabound character varying(1) COLLATE pg_catalog."default" NOT NULL,
    startdat character varying(10) COLLATE pg_catalog."default" NOT NULL,
    f_stdat character varying(4) COLLATE pg_catalog."default" NOT NULL,
    enddate character varying(10) COLLATE pg_catalog."default" NOT NULL,
    f_endat character varying(4) COLLATE pg_catalog."default" NOT NULL,
    popu_lsa integer NOT NULL,
    f_poplsa character varying(4) COLLATE pg_catalog."default" NOT NULL,
    popu_und integer NOT NULL,
    f_popund character varying(4) COLLATE pg_catalog."default" NOT NULL,
    centlib smallint NOT NULL,
    f_cenlib character varying(4) COLLATE pg_catalog."default" NOT NULL,
    branlib smallint NOT NULL,
    f_brlib character varying(4) COLLATE pg_catalog."default" NOT NULL,
    bkmob smallint NOT NULL,
    f_bkmob character varying(4) COLLATE pg_catalog."default" NOT NULL,
    master numeric(7,2) NOT NULL,
    f_master character varying(4) COLLATE pg_catalog."default" NOT NULL,
    libraria numeric(7,2) NOT NULL,
    f_librar character varying(4) COLLATE pg_catalog."default" NOT NULL,
    othpaid numeric(7,2) NOT NULL,
    f_othstf character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    f_totstf character varying(4) COLLATE pg_catalog."default" NOT NULL,
    locgvt integer NOT NULL,
    f_locgvt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    stgvt integer NOT NULL,
    f_stgvt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    fedgvt integer NOT NULL,
    f_fedgvt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    othincm integer NOT NULL,
    f_othinc character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totincm integer NOT NULL,
    f_totinc character varying(4) COLLATE pg_catalog."default" NOT NULL,
    salaries integer,
    f_salx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    benefit integer,
    f_benx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    staffexp integer,
    f_tostfx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    prmatexp integer NOT NULL,
    f_prmatx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    elmatexp integer NOT NULL,
    f_elmatx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    othmatex integer NOT NULL,
    f_otmatx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totexpco integer NOT NULL,
    f_tocolx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    othopexp integer,
    f_othopx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totopexp integer NOT NULL,
    f_totopx character varying(4) COLLATE pg_catalog."default" NOT NULL,
    lcap_rev integer NOT NULL,
    f_lcaprv character varying(4) COLLATE pg_catalog."default" NOT NULL,
    scap_rev integer NOT NULL,
    f_scaprv character varying COLLATE pg_catalog."default" NOT NULL,
    fcap_rev integer NOT NULL,
    f_fcaprv character varying COLLATE pg_catalog."default" NOT NULL,
    ocap_rev integer NOT NULL,
    f_ocaprv character varying COLLATE pg_catalog."default" NOT NULL,
    cap_rev integer NOT NULL,
    f_tcaprv character varying COLLATE pg_catalog."default" NOT NULL,
    capital integer NOT NULL,
    f_tcapx character varying COLLATE pg_catalog."default" NOT NULL,
    bkvol integer NOT NULL,
    f_bkvol character varying(4) COLLATE pg_catalog."default" NOT NULL,
    ebook integer NOT NULL,
    f_ebook character varying(4) COLLATE pg_catalog."default" NOT NULL,
    audio_ph integer NOT NULL,
    f_aud_ph character varying(4) COLLATE pg_catalog."default" NOT NULL,
    audio_dl integer NOT NULL,
    f_aud_dl character varying(4) COLLATE pg_catalog."default" NOT NULL,
    video_ph integer NOT NULL,
    f_vid_ph character varying(4) COLLATE pg_catalog."default" NOT NULL,
    video_dl integer NOT NULL,
    f_vid_dl character varying(4) COLLATE pg_catalog."default" NOT NULL,
    db_lo_ot integer NOT NULL,
    f_db_l_o character varying(4) COLLATE pg_catalog."default" NOT NULL,
    db_st integer NOT NULL,
    f_db_st character varying(4) COLLATE pg_catalog."default" NOT NULL,
    databases integer NOT NULL,
    f_dbase character varying(4) COLLATE pg_catalog."default" NOT NULL,
    subscrip integer NOT NULL,
    f_prsub character varying(4) COLLATE pg_catalog."default" NOT NULL,
    hrs_open integer NOT NULL,
    f_hrs_op character varying(4) COLLATE pg_catalog."default" NOT NULL,
    visits integer NOT NULL,
    f_visits character varying(4) COLLATE pg_catalog."default" NOT NULL,
    referenc integer NOT NULL,
    f_refer character varying(4) COLLATE pg_catalog."default" NOT NULL,
    regbor integer NOT NULL,
    f_regbor character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totcir integer NOT NULL,
    f_totcir character varying(4) COLLATE pg_catalog."default" NOT NULL,
    kidcircl integer NOT NULL,
    f_kidcir character varying COLLATE pg_catalog."default" NOT NULL,
    loanto integer NOT NULL,
    f_loanto character varying(4) COLLATE pg_catalog."default" NOT NULL,
    loanfm integer NOT NULL,
    f_loanfm character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totpro integer NOT NULL,
    f_totpro character varying(4) COLLATE pg_catalog."default" NOT NULL,
    kidpro integer NOT NULL,
    f_kidpro character varying(4) COLLATE pg_catalog."default" NOT NULL,
    yapro integer NOT NULL,
    f_yapro character varying(4) COLLATE pg_catalog."default" NOT NULL,
    totatten integer NOT NULL,
    f_totatt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    kidatten integer NOT NULL,
    f_kidatt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    yaatten integer NOT NULL,
    f_yaatt character varying(4) COLLATE pg_catalog."default" NOT NULL,
    gpterms integer NOT NULL,
    f_gpterm character varying(4) COLLATE pg_catalog."default" NOT NULL,
    pitusr integer NOT NULL,
    f_pitusr character varying(4) COLLATE pg_catalog."default" NOT NULL,
    yr_sub integer NOT NULL,
    obereg character varying(2) COLLATE pg_catalog."default" NOT NULL,
    rstatus integer NOT NULL,
    statstru character varying(2) COLLATE pg_catalog."default" NOT NULL,
    statname character varying(2) COLLATE pg_catalog."default" NOT NULL,
    stataddr character varying(2) COLLATE pg_catalog."default" NOT NULL,
    longitud numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL,
    fipsst character varying(2) COLLATE pg_catalog."default" NOT NULL,
    fipsco character varying(3) COLLATE pg_catalog."default" NOT NULL,
    fipsplac character varying(5) COLLATE pg_catalog."default" NOT NULL,
    cntypop integer NOT NULL,
    locale character varying(2) COLLATE pg_catalog."default" NOT NULL,
    centract numeric(7,2) NOT NULL,
    cenblock character varying(4) COLLATE pg_catalog."default" NOT NULL,
    cdcode character varying(4) COLLATE pg_catalog."default" NOT NULL,
    cbsa integer NOT NULL,
    microf character varying(2) COLLATE pg_catalog."default" NOT NULL,
    gal character varying(20) COLLATE pg_catalog."default" NOT NULL,
    galms character varying(4) COLLATE pg_catalog."default" NOT NULL,
    postms character varying(4) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT fscskey2012_key PRIMARY KEY (fscskey)
)

TABLESPACE pg_default;

ALTER TABLE public.imls_library_survey_2012
    OWNER to postgres;
-- Index: city2012_idx

-- DROP INDEX public.city2012_idx;

CREATE INDEX city2012_idx
    ON public.imls_library_survey_2012 USING btree
    (city COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: libname2012_idx

-- DROP INDEX public.libname2012_idx;

CREATE INDEX libname2012_idx
    ON public.imls_library_survey_2012 USING btree
    (libname COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: stabr2012_idx

-- DROP INDEX public.stabr2012_idx;

CREATE INDEX stabr2012_idx
    ON public.imls_library_survey_2012 USING btree
    (stabr COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: visits2012_idx

-- DROP INDEX public.visits2012_idx;

CREATE INDEX visits2012_idx
    ON public.imls_library_survey_2012 USING btree
    (visits ASC NULLS LAST)
    TABLESPACE pg_default;

-- Counting Rows and Values Using count()
-- Primary Syntax
SELECT COUNT(*) FROM table_name; -- Counts all rows and values in the table

SELECT COUNT(column_name) FROM table_name; -- Counts the values in the specified column

---------------------------------------------------------------------------------------------------------
SELECT COUNT(*) FROM imls_library_survey_2010; -- Counts all rows and values in imls_library_survey_2010

SELECT COUNT(*) FROM imls_library_survey_2012; -- Counts all rows and values in imls_library_survey_2012

SELECT COUNT(*) FROM imls_library_survey_2016; -- Counts all rows and values in imls_library_survey_2016

---------------------------------------------------------------------------------------------------------
SELECT COUNT(salaries) FROM imls_library_survey_2012; -- Counts all values in the salaries column.

SELECT COUNT(salaries) FROM imls_library_survey_2016; -- Counts all values in the salaries column.

SELECT COUNT(DISTINCT libname) FROM imls_library_survey_2010; -- Counts distinct values in the libname column

SELECT COUNT(DISTINCT libname) FROM imls_library_survey_2016; -- Counts distinct values in the libname column
----------------------------------------------------------------------------------------------------------
-- FINDING THE MAX() AND MIN() VALUES
SELECT MAX(visits), MIN(visits)
FROM imls_library_survey_2010; -- Finds the maximum and minimum visitation times in the 2010 visits column

SELECT MAX(visits), MIN(visits)
FROM imls_library_survey_2016; -- Finds the maximum and minimum visitation times in the 2016 visits column

-- N.B: In my results it gave a min of -3 which does not represent a reasonable quantity of visitations. Use the following syntax:
SELECT MAX(visits), MIN(visits)
FROM imls_library_survey_2010
WHERE visits >= 0; -- This gives me the MAX value of 17786153 and a MIN value of 0

SELECT MAX(visits), MIN(visits)
FROM imls_library_survey_2016
WHERE visits >= 0; -- This gives me the MAX value of 17420607 and a MIN value of 0
-------------------------------------------------------------------------------------------------------------
-- Aggregate Data Using GROUP BY
SELECT stabr, city, cnty
FROM imls_library_survey_2010
GROUP BY stabr, city, cnty
ORDER BY stabr; -- Groups states ,cities and counties and shows the results in order by states.

-- Combining GROUP BY with COUNT()
-- In this procedure I am looking to count the library agencies in each state.
SELECT stabr, COUNT(*)
FROM imls_library_survey_2010
GROUP BY stabr
ORDER BY COUNT(*) 

-- Using GROUP BY on Multiple Columns with COUNT()
SELECT stabr, stataddr, COUNT(*)
FROM imls_library_survey_2010
GROUP BY stabr, stataddr
ORDER BY stabr ASC, COUNT(*) DESC;
-- N.B: The values for stataddr: 00 - NO CHANGE FROM LAST YEAR; 07 - MOVED TO A NEW LOCATION; 15 - MINOR ADDRESS CHANGE

-- Finding SUM() of visits 
SELECT SUM(visits)
FROM imls_library_survey_2010
WHERE visits >= 0; -- Sums all the visits that are more than or equals to zero.

SELECT SUM(visits)
FROM imls_library_survey_2016
WHERE visits >= 0; -- Sums all the visits that are more than or equals to zero.

-- OR 

SELECT SUM(imls2010.visits) AS visits_2010,
        SUM(imls2016.visits) AS visits_2016
FROM imls_library_survey_2010 AS imls2010 INNER JOIN imls_library_survey_2016 AS imls2016
ON imls2010.fscskey = imls2016.fscskey
WHERE imls2010.visits >= 0 AND imls2016.visits >= 0; -- visits_2010 == 1566903969; visits_2016 == 1347406856

-- Grouping Visits Sums by State (stabr)

SELECT imls2016.stabr,
        SUM(imls2016.visits) AS visits_2016,
        SUM(imls2010.visits) AS visits_2010,
        ROUND((CAST(SUM(imls2016.visits) AS NUMERIC(10, 1)) - SUM(imls2010.visits)) / SUM(imls2010.visits) * 100, 2) AS pct_change
FROM imls_library_survey_2016 AS imls2016 INNER JOIN imls_library_survey_2010 AS imls2010
ON imls2016.fscskey = imls2010.fscskey
WHERE imls2016.visits >= 0 AND imls2010.visits >= 0
GROUP BY imls2016.stabr
ORDER BY pct_change DESC;

-- Filtering an aggregate query using HAVING.
-- N.B: WHERE clause can't be used with an aggreagates functions for filtering because they operate within a row
--      but the HAVING clause can be used with aggregate functions because it operates across rows
SELECT imls2016.stabr,
        SUM(imls2016.visits) AS visits_2016,
        SUM(imls2010.visits) AS visits_2010,
        ROUND((CAST(SUM(imls2016.visits) AS NUMERIC(10, 1)) - SUM(imls2010.visits)) / SUM(imls2010.visits) * 100, 2) AS pct_change
FROM imls_library_survey_2016 AS imls2016 INNER JOIN imls_library_survey_2010 AS imls2010
ON imls2016.fscskey = imls2010.fscskey
WHERE imls2016.visits >= 0 AND imls2010.visits >= 0
GROUP BY imls2016.stabr
HAVING SUM(imls2016.visits) > 17000000
ORDER BY pct_change DESC;

-- Finding changes in library digital patterns
-- The two values used to evaluate these patterns are GPTERMS: The number of internet-connected computers used by the public
-- PITUSR: The number of uses of internet computers per year
SELECT imls2016.stabr,
		SUM(imls2016.gpterms) AS total_connected_pcs_2016,
		SUM(imls2010.gpterms) AS total_connected_pcs_2010,
		ROUND((CAST(SUM(imls2016.gpterms) AS numeric(10, 1)) - SUM(imls2010.gpterms)) / SUM(imls2010.gpterms) * 100, 2) AS pct_change_gpterms,
		SUM(imls2016.pitusr) AS tot_pitusr_2016,
		SUM(imls2010.pitusr) AS tot_pitusr_2010,
		ROUND((CAST(SUM(imls2016.pitusr) AS numeric(10, 1)) - SUM(imls2010.pitusr)) / SUM(imls2010.pitusr) * 100, 2) AS pct_change_pitusr
FROM imls_library_survey_2016 AS imls2016 INNER JOIN imls_library_survey_2010 AS imls2010
ON imls2016.fscskey = imls2010.fscskey
WHERE imls2016.gpterms >= 0 AND imls2010.gpterms >= 0 AND imls2016.pitusr >= 0 AND imls2010.pitusr >= 0
GROUP BY imls2016.stabr
ORDER BY imls2016.stabr;

-- Finding the percentage change in visits by regions using obereg as the primary key
-- Bureau of Economic Analysis Code (formerly, Office of Business Economics)
-- 01–New England (CT ME MA NH RI VT)
-- 02–Mid East (DE DC MD NJ NY PA)
-- 03–Great Lakes (IL IN MI OH WI)
-- 04–Plains (IA KS MN MO NE ND SD)
-- 05–Southeast (AL AR FL GA KY LA MS NC SC TN VA WV)
-- 06–Southwest (AZ NM OK TX)
-- 07–Rocky Mountains (CO ID MT UT WY)
-- 08–Far West (AK CA HI NV OR WA)
-- 09–Outlying Areas (AS GU MP PR VI)

CREATE TABLE imls_regions (
	obereg varchar(2) CONSTRAINT regkey PRIMARY KEY,
	obereg_name text
);

INSERT INTO imls_regions (obereg, obereg_name)
VALUES ('01', 'New England'),
		('02', 'Mid East'),
		('03', 'Great Lakes'),
		('04', 'Plains'),
		('05', 'SouthEast'),
		('06', 'SouthWest'),
		('07', 'Rocky Mountains'),
		('08', 'Far West'),
		('09', 'Outlying Areas');

SELECT imlsreg.obereg,
		imlsreg.obereg_name,
		SUM(imls2016.visits) AS total_visits_2016,
		SUM(imls2010.visits) AS total_visits_2010,
		ROUND((CAST(SUM(imls2016.visits) AS decimal(14, 1)) - SUM(imls2010.visits)) / SUM(imls2010.visits) * 100, 2) AS pct_change_in_visits
FROM imls_regions AS imlsreg INNER JOIN imls_library_survey_2016 AS imls2016
ON imlsreg.obereg = imls2016.obereg
INNER JOIN imls_library_survey_2010 AS imls2010
ON imlsreg.obereg = imls2010.obereg
WHERE imls2016.visits >= 0 AND imls2010.visits >= 0
GROUP BY imlsreg.obereg, imlsreg.obereg_name
ORDER BY pct_change_in_visits ASC;