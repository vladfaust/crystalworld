#!/usr/bin/env node

const yaml  = require('js-yaml')
const shell = require('shelljs')
const fs    = require('fs')

let doc

try {
  doc = yaml.safeLoad(fs.readFileSync(`${__dirname}/../shard.yml`, 'utf8'))
} catch (err) {
  console.error(err)
  process.exit(-1)
}

if (process.env.ONYX_COMMIT || process.env.ONYX_HTTP_COMMIT || process.env.ONYX_SQL_COMMIT) {
  if (process.env.ONYX_COMMIT) {
    console.log(`Updating onyx commit to ${process.env.ONYX_COMMIT}`)

    delete doc.dependencies.onyx.version
    doc.dependencies.onyx.commit = process.env.ONYX_COMMIT
  }

  if (process.env.ONYX_HTTP_COMMIT) {
    console.log(`Updating onyx-http commit to ${process.env.ONYX_HTTP_COMMIT}`)

    delete doc.dependencies['onyx-http'].version
    doc.dependencies['onyx-http'].commit = process.env.ONYX_HTTP_COMMIT
  }

  if (process.env.ONYX_SQL_COMMIT) {
    console.log(`Updating onyx-sql commit to ${process.env.ONYX_SQL_COMMIT}`)

    delete doc.dependencies['onyx-sql'].version
    doc.dependencies['onyx-sql'].commit = process.env.ONYX_SQL_COMMIT
  }

  try {
    fs.writeFileSync(`${__dirname}/../shard.yml`, yaml.safeDump(doc))
    console.log(`Updated shard.yml`)
  } catch (err) {
    console.error(err)
    process.exit(-1)
  }

  shell.exec("shards update")
}

